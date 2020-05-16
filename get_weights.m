function w = get_weights(res,K,crit,thres)
  [nt,nm,nr] = size(res);
  res = reshape(sum(res,1),nm,nr);
  switch crit
    case "AKAIKE"
      a = nt*log(res/nt);
      b = 2*(K+1);  b(K>nt/40)=b.*(nt./(nt-K-2));
      AIC = a+b;
      ed  = exp(-(AIC - min(AIC))/2);
      w     = (1./sum(ed,1)).*ed;
    case "RMS"
      r = 1./((1./(nt-K-1)).*res);
      w = (1./sum(r,1)).*r;
    case "EQUAL"
      w = ones(nm,nr)/nm;
    otherwise
  end
  w(w<min(thres,1/nm)) = 0;
  w = (1./sum(w,1)).*w;
end