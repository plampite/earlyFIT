function dy = sir_ode(t,y,p,usrfn)
  dy    = zeros(3,1);
  beta  = p(3);
  if !strcmp(usrfn,"NONE"), beta=beta*user_functions(t,p(6:end),usrfn,y(2)/p(2)); end
  dy(1) = -beta*y(1)*y(2)^p(5)/p(2);           %dS/dt = -beta*S*I^alpha/N
  dy(2) =  beta*y(1)*y(2)^p(5)/p(2)-p(4)*y(2); %dI/dt =  beta*S*I^alpha/N - gamma*I
  dy(3) =                           p(4)*y(2); %dR/dt =                     gamma*I
end