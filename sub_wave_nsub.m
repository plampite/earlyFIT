function nsub = sub_wave_nsub(Cthr,p,qtoll,nmax)   
  K = p(2);
  q = p(6);
  if (Cthr>K)
    nsub = 1;
  else
    if (q<=qtoll)
      nsub = nmax;
    else
      nsub = max(floor(-(1/q)*log(Cthr/K)+1),1);
    end
    nsub = min(nsub,nmax);
  end
end