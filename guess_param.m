function [betamin,beta,betamax,data] = guess_param(t,y0,model,usrfn,bmin,beta0,bmax,data0)
  %Guess of parameters from data
  
  %We start from a very crude guess of C0 and K that will always return values
  i0 = min(find(y0>0)); if (isempty(i0)), i0=1; end
  C0 = max(y0(i0),1)/max(t(i0),1); %First non zero val divided by number of days
  Kmin = max(y0(end),1); %Maximum value in data is obviously new minimum K
  K    = 2*Kmin;         %Maximum value x 2
  
  %Then we filter the data
  y = myfilter(y0,(1/6)*ones(10,1));
  
  %Cut data at peak of daily cases (ypeak is also used by SUB-WAVE model)
  [~,imax]=max([y(1); diff(y)]);
  ypeak = y(imax);
  tpeak = t(imax);

  %And use an exponential trough the peak to compute a crude r
  r = log(ypeak/C0)/tpeak;
  
  guess = [C0;K;r;1];
  
  %So far so good, now we use data til the peak to add more estimates
  n  = imax;
  
  %We start with a finer exponential estimate, if possible
  for i = 1:n-1
    dt = t(n)-t(i);
    if (y(i)>0 && dt>0 && y(n)>y(i))
      r    = log(y(n)/y(i))/dt;
      C0   = (y(n)-y(i))/exp(r*dt);
      guess = [guess [C0;K;r;1]];
      break
    end
  end
    
  %We now go for a set of logistic(a=1)/richards estimates
  for a = 0.25:0.25:1
    for k = 1:n-2
      %take 3 equispaced points: k=i-2*m < j=i-m < i, m=i-j=j-k -> j=(i+k)/2
      i  = n-1+mod(n-k+1,2);
      j  = (i + k)/2; 
      dt = t(j)-t(k);
      
      rguess = richards_guess(y(i),y(j),y(k),dt,a);
      if (!isempty(rguess))
        rguess(2) = max(Kmin,rguess(2));
        guess     = [guess rguess];
        break
      end
    end
  end
  data = data0;
  if strcmp(model,'SUB-WAVE') data = [ypeak]; end

  %Now that we have these initial estimates, the best thing is to test them all
  %and set the the initial value with the most promising one. The initial beta
  %input will be used also as reference for the first evaluation
  %We still use filtered data for this (otherwise use y0, instead of y, in res)
  %Also, you may want to use a different residual (e.g. max instead of sum)
  f    = growth_model(t,beta0,model,usrfn,data,"CUMUL");
  res  = sum((f-y).^2);
  beta = beta0;
  for i = 1:size(guess,2)
    [betamin,beta0,betamax,data] = from_guess_to_param(beta0,bmin,guess(:,i),bmax,data,Kmin,model,usrfn);
    f = growth_model(t,beta0,model,usrfn,data,"CUMUL");
    r = sum((f-y).^2);
    if (r<res)
      res  = r;
      beta = beta0;
    end
  end
   %Sometimes the best guess has K < Kmin
  beta = max(betamin,min(beta,betamax));
end