function [betamin,beta0,betamax,data] = model_param(model,usrfn)
  %Sets the initial values and bounds for the parameters in the model
  
  data=[];
  switch model
    case 'EXP'      %C0,r
      betamin = [0;0];
      betamax = [1e9;1e9];
      beta0   = [10;0.19];
    case 'GGM'      %C0,r,p
      betamin = [0;0;0];
      betamax = [1e9;1e9;1-1e9];
      beta0   = [10;0.19;0.99];
    case 'LOGISTIC' %C0,K,r
      betamin = [0;1;0];
      betamax = [1e9;1e9;1e9];
      beta0   = [10;1e4;0.19];
    case 'GOMPERTZ' %C0,b,r (b=r/log(K/C0))
      betamin = [0;1e-9;0];
      betamax = [1e9;1e9;1e9];
      beta0   = [10;0.02;0.19];
    case 'RICHARDS' %C0,K,r,a
      betamin = [0;1;0;1e-9];
      betamax = [1e9;1e9;1e9;20];
      beta0   = [10;1e4;0.19;1];
    case 'GENGOM'   %C0,b,r,p
      betamin = [0;1e-9;0;0];
      betamax = [1e9;1e9;1e9;1-1e-9];
      beta0   = [10;0.02;0.19;0.99];
    case 'GENLOG'   %C0,K,r,p
      betamin = [0;1;0;0];
      betamax = [1e9;1e9;1e9;1];
      beta0   = [10;1e4;0.19;1];
    case 'GENRIC'   %C0,K,r,p,a
      betamin = [0;1;0;0;0];
      betamax = [1e9;1e9;1e9;1;20];
      beta0   = [10;1e4;0.19;1;1];
    case 'SUB-WAVE' %C0,K,r,p,a,q,Cf
      betamin = [0;1;0;0;0;0;1e-3];
      betamax = [1e9;1e9;1e9;1;20;1e9;1];
      beta0   = [10;1e4;0.19;1;1;1;1];
      data    = [200]; %Cthr
    case 'SIR'      %I0,N,beta,gamma       - I0 as fraction of N
      betamin = [0;1;0;0];
      betamax = [1;1e9;1e9;1e9];
      beta0   = [1e-3;1e4;0.3;0.1];
    case 'SIR-NHM'  %I0,N,beta,gamma,alpha - I0 as fraction of N
      betamin = [0;1;0;0;0];
      betamax = [1;1e9;1e9;1e9;1];
      beta0   = [1e-3;1e4;0.3;0.1;1];
    case 'SEIR'     %I0,N,beta,gamma,kappa - I0 as fraction of N
      betamin = [0;1;0;0;0];
      betamax = [1;1e9;1e9;1e9;1e9];
      beta0   = [1e-3;1e4;0.3;0.1;0.1];
    case 'SEmInR'   %I0,N,beta,gamma,kappa - I0 as fraction of N
      betamin = [0;1;0;0;0];
      betamax = [1;1e9;1e9;1e9;1e9];
      beta0   = [1e-3;1e4;0.3;0.1;0.1];
      data    = [2; 2]; %m,n
    otherwise
      error("Unrecognized model");
  end
  switch usrfn
    case 'NONE'
      %Do nothing
    case 'LIN'
      betamin = [betamin; 0;-1e9];
      betamax = [betamax; 1e9;1e9];
      beta0   = [beta0; 1;0];
    case 'GOM'
      betamin = [betamin; 0;1e-9];
      betamax = [betamax; 1e9;1e9];
      beta0   = [beta0; 10;0.03];
    case 'BETADECAY'
      betamin = [betamin; 0;0;0];
      betamax = [betamax; 1;1e9;1e9];
      beta0   = [beta0; 0.25;0.25;20];
    case 'BETAEXP'
      betamin = [betamin; 0];
      betamax = [betamax; 1e9];
      beta0   = [beta0; 0];
    case 'BETARAT'
      betamin = [betamin; 0];
      betamax = [betamax; 1e9];
      beta0   = [beta0; 0];
    case 'BETASIN'
      betamin = [betamin; 0;0;0;0];
      betamax = [betamax; 1;0.25;1;1e9];
      beta0   = [beta0; 0;0;0;0];
    otherwise
      error("Unrecognized user function");
  end
end