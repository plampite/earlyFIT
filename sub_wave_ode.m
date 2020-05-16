function dy = sub_wave_ode(t,y,p,Cthr,nsub)
  global A;
  dy=zeros(nsub,1);
  for i=1:nsub
      if (A(i)==0), A(i)=(y(i-1)>=Cthr); end
      Ki=p(2)*exp(-p(6)*(i-1)); 
      dy(i)=A(i)*(p(3)*(y(i)^p(4))*(1-(y(i)/Ki)^p(5))); 
  end
end