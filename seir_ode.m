function dy = seir_ode(t,y,p,usrfn)
  dy    = zeros(4,1);
  beta  = p(3);
  if !strcmp(usrfn,"NONE"), beta=beta*user_functions(t,p(6:end),usrfn,y(3)/p(2)); end
  dy(1) = -beta*y(1)*y(3)/p(2);                     %dS/dt = -beta*S*I/N
  dy(2) =  beta*y(1)*y(3)/p(2)-p(5)*y(2);           %dE/dt =  beta*S*I/N - kappa*E
  dy(3) =                      p(5)*y(2)-p(4)*y(3); %dI/dt =               kappa*E - gamma*I
  dy(4) =                                p(4)*y(3); %dR/dt =                         gamma*I
end