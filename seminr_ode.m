function dy = seminr_ode(t,y,p,m,n,usrfn)
  ms   = 1; 
  dy   = zeros(m+n+2,1);
  beta = p(3);
  I    = sum(y(m+2:m+n+1));
  if !strcmp(usrfn,"NONE"), beta=beta*user_functions(t,p(6:end),usrfn,I/p(2)); end
  dS = beta*y(1)*I/p(2);
  dy(1) = -dS;                        %dS/dt  = -beta*S*I/N
  if m>0
    dy(2) = dS-m*p(5)*y(2);           %dE1/dt =  beta*S*I/N - m*kappa*E1
    for i = 2:m
      dy(i+1) = m*p(5)*(y(i)-y(i+1)); %dEi/dt =               m*kappa*(Ei-1 - Ei)
    end
    ms = 0;
  end
  dy(m+2) = ms*dS+(1-ms)*m*p(5)*y(m+1)-n*p(4)*y(m+2); %dI1/dt = ms*beta*S*I/N + (1-ms)*m*kappa*Em - n*gamma*I1
  for j = 2:n
    dy(m+1+j) = n*p(4)*(y(m+j)-y(m+1+j));             %dIj/dt = n*gamma*(Ij-1 - Ij) 
  end
  dy(m+n+2) = n*p(4)*y(m+n+1);                        %dR/dt  = n*gamma*In
end