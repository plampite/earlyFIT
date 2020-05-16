function y = add_error(y0,factor)
  m = abs(diff(y0)); %This is the mean for all the distributions
  if factor<1
    %Binomial distribution
    p  = (1-abs(factor))*ones(size(m));
    n  = round(m./p);
    dy = binornd(n,p);
  elseif factor==1
    %Poisson distribution
    dy = poissrnd(m);
  else
    %Negative binomial distribution
    p  = 1./(factor*ones(size(m)));
    n  = m.*p./(1-p);
    dy = nbinrnd(n,p);   
  end
  y = cumsum([y0(1); dy]);
end
  