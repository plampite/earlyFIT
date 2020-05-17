clear all
close all
clc
%-----------------------------INPUT SECTION-------------------------------------
%Input and output directories
idir="input";
odir="output";

%Save output data to
outfile="earlyFIT.mat";

%Choose source of data
%"COVIDITA", "COVIDJHU" or "filename.ext" to be found in idir 
source="COVIDJHU";

%Choose variable to use
%"CASES" or "DEATHS" if using COVIDXXX databases
%(but for most models it only makes sense to use "CASES")
vars="CASES";

%Type of analysis
%""    -> All the regions separately
%"ALL" -> All regions as a whole (sum data before the fit)
%"XYZ" -> Region XYZ only, reverts to "ALL" if "XYZ" does not exist in data source
ana="Italy";

%Choose if using cumulative or daily values for the fit
%Note that original data must be cumulative in any case 
%"CUMUL" or "DAILY"
dtype="CUMUL";

%Preprocessing parameters (see dedicated subroutine)
prepro="STA";
prepar=[100];

%Models and user functions, one user function per model

%Models to fit data. Available ones are:
%"EXP","GGM","LOGISTIC","GOMPERTZ","RICHARDS","GENGOM" - Analytical solution
%"GENLOG","GENRIC","SIR"                               - 1 ODE
%"SUB-WAVE"                                            - 1 or more ODE
%"SIR-NHM"                                             - 3 ODE
%"SEIR"                                                - 4 ODE
%"SEmInR"                                              - m+n+2 ODE (m=>0,n>0)
%Only the first 6 have analytical solutions and are fast enough. The remaining ones
%are based on one or multiple ODEs and might be sensibly slower to fit.
models = {"GOMPERTZ"};

%User functions to use in models. Default is "NONE" (not using any function)
%When used with "EXP", "GGM", "LOGISTIC" and "RICHARDS", this function, say, f,
%is used to model the growth rate r as r(t) = r0 df/dt
%When used with "SIR-NHM", "SEIR" and "SEmInR" it is used to model beta as beta(t) = beta0 f(t)
usrfns = {"NONE";"NONE";"NONE";"NONE";"NONE"}; %It's OK if this is larger than models

%Bootstrapping options
M      = 0;            %Number of resamples (>100 is better)
factor = 0;              %factor = var/mean (<1 Binomial, 1 Poisson, >1 Negative Binomial, <=0 Estimated from data)
quant  = [0.025; 0.975]; %Lower and upper quantiles for the confidence intervals

%Note that bootstraping S models M times over R regions implies:
%1) RS(1+M) Minimizations (altough, only the first RS might be harder/longer)
%2) RM^S bootstrapped curves (linear combinations of the above)
%Thus, if you want RN total bootstrapped curves you can pick one of the following:
%a) M = N^(1/S)       if you want to have S models
%b) S = log(N)/log(M) if you want to have M samples per model

%Ensemble criterion (how are the different models weighted):
%"AKAIKE","RMS","EQUAL"
crit      = "RMS";
threshold = 0.01; %Discard models whose weight is below this value

%For how many days you want to extrapolate model results
npre=30;

%Max. number of iterations and tollerance for the fitting
nit = 400;  tol = 1e-5;
%---------------------------END OF INPUT SECTION--------------------------------
if is_octave
  %global verbose=1; %To visualize iterations, for debug purposes only
  pkg load optim    %Needed by leasqr in fit_model
  pkg load io       %Needed by csv2cell in subroutines called by load_data
end

%Load data from specified source
[labels,t,y] = load_data(vars,ana,source,idir);

%Pre-process data (just a general routine to modify at will)
[labels,t,y] = pre_process(t,y,prepro,prepar,labels);

%Times for the desired extrapolation (npre time units)
te = (t(end):t(end)+npre)';

%The data structure that will contain all the results
nm = length(models);
C  = cell(5,nm);

%Loop over models
for i = 1:nm
  model=models{i};
  usrfn=usrfns{i};
  
  %Fit data with chosen model
  [f,beta,data,bmin,bmax] = fit_model(t,y,model,usrfn,labels,dtype,nit,tol);
  
  %Bootstrap + extrapolation
  [fi,betai,res,ei] = bootstrap(t,y,f,te,bmin,beta,bmax,data,labels,model,usrfn,dtype,M,nit,tol,factor);
    
  %Pack all relevant data
  C{1,i} = fi;    %fittings
  C{2,i} = ei;    %extrapolations
  C{3,i} = betai; %best fit parameters
  C{4,i} = data;  %auxiliary data for the models
  C{5,i} = res;   %residuals of the mean fit
end

%Let's clear some memory as the next part might be hungry of that
clear f beta res fi betai ei data bmin bmax

%Final ensemble and resulting statistics
[f,fl,fu,e,el,eu,wi] = ensemble(C,quant,crit,threshold);

%Save everything
if !exist(odir,"dir"), mkdir(odir); end; save(fullfile(odir,outfile));

%Plot results
output_stuff(labels,t,y,f,fl,fu,te,e,el,eu,odir);

%In case you might want to sum all the regions together
%output_stuff({source},t,sum(y,2),sum(f,2),sum(fl,2),sum(fu,2),te,sum(e,2),sum(el,2),sum(eu,2),odir);
