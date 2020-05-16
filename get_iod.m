function D = get_iod(y,f,factor)
  %Index of dispersion
  if factor>0
    %Given
    D=factor*ones(1,size(y,2));
  else
    %Estimated (we can probably do better than this)
    D=mean((diff(y)-diff(f)).^2./diff(f));
  end
end
