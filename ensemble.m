function [f,fl,fu,e,el,eu,wi] = ensemble(C,quant,crit,threshold)
  nm = size(C,2);
  [nt,ns,nr] = size(C{1,1});
  ne = size(C{2,1},1);

  %Compute the model weights for the ensemble
  %1) Residuals reshaped as a single nt x nm x nreg matrix
  res = reshape(cat(1,C{5,:}),nt,nm,nr);
  %2) Taking the number of parameters for each of the chosen models
  K   = cellfun("size",C(3,:),1)';                      
  %3) The actual weights (nm x nr matrix)
  wi  = get_weights(res,K,crit,threshold);
  
  %Total number of samples
  ntot = ns^nm;         %All the permutations of nm indices from 1 to ns 
  %We do it with the smallest possible amount of memory but, if quantiles could
  %be estimated just from sample mean and variance this could be much better
  %because you won't need tmp anymore because you can compute mean and variance
  %online. Then, probably, it would make sense to explore vectorization.
  %Also, using mean and variances and higher order moments would probably allow
  %using algebra of random variables on the confidence intervals in the post
  %processing
  tmp  = zeros(ntot,1);
  
  %Initializations
  f  = zeros(nt,nr);
  fl = zeros(nt,nr);
  fu = zeros(nt,nr);
  
  e  = zeros(ne,nr);
  el = zeros(ne,nr);
  eu = zeros(ne,nr);
  
  %Loop over the regions
  for j = 1:nr
    %Loop over the current time steps
    for i = 1:nt
      %Collect all the samples for the given time
      for k = 1:ntot
        sub = 1+rem(floor(((k-.5)*(ns.^(1-nm:0)))),ns); %ind2sub (sort of)
        tmp(k)=0;
        for m=1:nm
          tmp(k) = tmp(k) + wi(m,j)*C{1,m}(i,sub(m),j); %weighted sum of the samples
        end
      end
      %Extract mean and quantiles (we can probably do better than this)
      f(i,j)  = mean(tmp);
      fl(i,j) = quantile(tmp,quant(1));
      fu(i,j) = quantile(tmp,quant(2));
    end
    %Loop over the extrapolated time steps
    for i = 1:ne
      %Collect all the samples for the given time
      for k = 1:ntot
        sub = 1+rem(floor(((k-.5)*(ns.^(1-nm:0)))),ns); %ind2sub (sort of)
        tmp(k)=0;
        for m=1:nm
          tmp(k) = tmp(k) + wi(m,j)*C{2,m}(i,sub(m),j); %weighted sum of the samples
        end
      end
      %Extract mean and quantiles (we can probably do better than this)
      e(i,j)  = mean(tmp);
      el(i,j) = quantile(tmp,quant(1));
      eu(i,j) = quantile(tmp,quant(2));     
    end   
  end 
end
