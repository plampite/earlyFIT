function [fi,betai,res,ei] = bootstrap(t,y,f,te,bmin,beta,bmax,data,labels,model,usrfn,dtype,M,nit,tol,factor)
  %Choose between bootstrapping or naive
  if M>0
    %Bootstrap (fit M new curves with mean from model, f, and given/estimated dispersion, D)
    %Previous fit for beta is, of course, used as initial value
    
    %Index of dispersion
    D = get_iod(y,f,factor);
    
    %Resample and refit M times
    [fi,betai] = fit_boots(t,f,bmin,beta,bmax,data,labels,model,usrfn,dtype,M,D,nit,tol);

    %Residuals from the mean of the M samples
    res=(y-squeeze(mean(fi,2))).^2;
    
    %Extrapolate all the M fittings of the model
    ei = evaluate_boots(te,betai,model,usrfn,data,"CUMUL");
  else
    %Naive (or pretend your fit doesn't just depend from the given data)
      
    %Residuals
    res=(y-f).^2;
    
    %Just extrapolate the fitted model
    e  = evaluate_model(te,beta,model,usrfn,data,"CUMUL");
    
    %Reshape as if M=1
    fi    = reshape(f,size(f,1),1,size(f,2));
    ei    = reshape(e,size(e,1),1,size(e,2));
    betai = reshape(beta,size(beta,1),1,size(beta,2));
  end
end
