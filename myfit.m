function [f,beta] = myfit(x,y,p0,model,usrfn,data,dtype,tol,nit,bounds)
  
  %Check if the data is daily or cumulative
  daily=strcmp(dtype,"DAILY");
  
  %If we work on daily data the input must be modified
  if daily, y=[y(1); diff(y)]; end
  
  if is_octave
    options.bounds = bounds;
    [f,beta,cvg,iter,corp,covp,covr,stdresid,Z,r2] = ...
    leasqr(x,y,p0,@(x,p) growth_model(x,p,model,usrfn,data,dtype),tol,nit,[],[],[],options);
  else
    error("Still have to workout the MATLAB version");
  end
  
  %If we work on daily data the output must be modified as well
  if daily, f=cumsum(f); end
end
