function [fi,betai] = fit_boots(t,f0,bmin,beta0,bmax,data,labels,model,usrfn,dtype,M,D,nit,tol)
  %We now take the previous best fit and build M replicas, sampled from a given
  %random distribution with the same mean of the fit, m, and a variance v=D*m
  %D<1 -> Binomial distribution
  %D=1 -> Poisson  distribution
  %D>1 -> Negative Binomial distribution
  %After this, we will have M samples we can use to build all the statistics
  
  %How many times and regions in the data
  [nt,nreg] = size(f0);

  %Initializations
  fi    = zeros(nt,M,nreg);
  betai = zeros(size(beta0,1),M,nreg);
    
  for j=1:nreg
    disp(["Bootstrapping " labels{j} " with " model " and M = " int2str(M)])
    
    for i=1:M
      disp(i)
      
      %Add error with D index of dispersion to the mean f0
      y = add_error(f0(:,j),D(j));
      
      %Fit the model parameters in the region
      [f,beta] = myfit(t,y,beta0(:,j),model,usrfn,data(:,j),dtype,tol,nit,[bmin(:,j) bmax(:,j)]);
      
      %Pack output
      fi(:,i,j)    = f;
      betai(:,i,j) = beta;
    end
  end
end
