function [f,beta,data,bmin,bmax] = fit_model(x,y,model,usrfn,labels,dtype,nit,tol)
  %Driver function to fit y data (one column per region) to model by the
  %Levemberg-Marquardt algorithm

  %Pick up initial and boundary values for parameters
  %(these are just manually picked reasonable values that don't depend on data)
  [betamin,beta0,betamax,datai] = model_param(model,usrfn);
  
  %How many times and regions in the data
  [nt,nreg] = size(y);

  %Initializations  
  f    = zeros(nt,nreg);
  beta = repmat(beta0,1,nreg);
  data = zeros(size(datai,1),nreg); 
  bmin = repmat(betamin,1,nreg);
  bmax = repmat(betamax,1,nreg);
  
  %Loop over regions
  for i=1:nreg
    disp(["Fitting " labels{i} " with " model])
    
    %Improve initial and boundary values and extract necessary datai
    [betamin,beta0,betamax,datai] = guess_param(x,y(:,i),model,usrfn,bmin(:,i),beta(:,i),bmax(:,i),datai);
       
    %Fit the model parameters in the region
    [fi,betai] = myfit(x,y(:,i),beta0,model,usrfn,datai,dtype,tol,nit,[betamin betamax]);
    
    %Pack output
    f(:,i)    = fi;
    beta(:,i) = betai;
    data(:,i) = datai;
    bmin(:,i) = betamin;
    bmax(:,i) = betamax;
  end
end