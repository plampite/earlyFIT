function [betamin,beta0,betamax,data] = from_guess_to_param(b0,bmin,guess,bmax,d,Kmin,model,usrfn)
  %Sets the initial values and bounds for the parameters in the model using the
  %the initial guess

  beta0   = b0;  
  betamin = bmin;
  betamax = bmax;
  data    = d;
  switch model
    case {'EXP','GGM'}           %C0,r[,p]
      beta0(1:2) = guess(1:2:3);
    case {'LOGISTIC','GENLOG'}   %C0,K,r[,p]
      betamin(2) = Kmin;
      beta0(1:3) = guess(1:3);
    case {'RICHARDS'}            %C0,K,r,a
      betamin(2) = Kmin;
      beta0(1:4) = guess(1:4);
    case {'GOMPERTZ','GENGOM'}   %C0,b,r[,p] (b=r/log(K/C0))
      b = guess(3)/log(guess(2)/guess(1));
      beta0(1:3) = [guess(1); b; guess(3)];
    case {'GENRIC','SUB-WAVE'}   %C0,K,r,p,a[,q,Cf]
      betamin(2) = Kmin;
      beta0(1:5) = [guess(1:3); beta0(4); guess(4)];
    case {'SIR','SIR-NHM'}       %I0,N,beta,gamma[,alpha] - I0 as fraction of N
      betamin(2) = Kmin;
      beta  = 3*guess(3);
      gamma = beta/1.5;
      N     = guess(2);
      I0    = guess(1)/N;
      beta0(1:4) = [I0;N;beta;gamma];
    case {'SEIR','SEmInR'}      %I0,N,beta,gamma,kappa - I0 as fraction of N
      betamin(2) = Kmin;
      beta  = 3*guess(3);
      gamma = beta/1.5;
      kappa = beta;
      N     = guess(2);
      I0    = guess(1)/N;
      beta0(1:5) = [I0;N;beta;gamma;kappa];
      if (strcmp(model,'SEmInR')) %help SEmInR iterations for m = 0 (SInR)
        if (data(1)==0)   %if m=0
          beta0(5)   = 0; %k = 0
          betamin(5) = 0; %kmin = 0
          betamax(5) = 0; %kmax = 0
        end
      end
    otherwise
      error("Unrecognized model");
  end
  switch usrfn
    case {'NONE','LIN','GOM','BETADECAY','BETAEXP','BETARAT','BETASIN'}
      %Do nothing
    otherwise
      error("Unrecognized user function");
  end
end