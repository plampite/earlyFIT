function ybar = myfilter(x,c)
  ybar=x;
  n=size(c,1);
  for j=1:n
    y=ybar;
    delta=c(j);
    ybar(1)   = (1+delta)*y(1)/2  +(1-delta)*y(2)/2;                   
    for i=2:length(ybar)-1
      ybar(i) = (1-delta)*y(i-1)/2 + delta*y(i) + (1-delta)*y(i+1)/2; 
    end
    ybar(end) = (1+delta)*y(end)/2+(1-delta)*y(end-1)/2;
  endfor
endfunction