function [C] = growth_model(x,p,model,usrfn,data,dtype)
  %Evaluates the model in x with parameters p, using additional data and/or the userfn
  
  %Check if using user function
  usefn=!strcmp(usrfn,"NONE");
  switch model
    case 'EXP'      %dC/dt = r C
      if usefn, x = user_functions(x,p(3:end),usrfn)-user_functions(zeros(size(x)),p(3:end),usrfn); end
      C  = p(1)*exp(p(2)*x);
    case 'GGM'      %dC/dt = r C^p
      if usefn, x = user_functions(x,p(4:end),usrfn)-user_functions(zeros(size(x)),p(4:end),usrfn); end
      C = (p(1)^(1-p(3))+p(2)*(1-p(3))*x).^(1/(1-p(3)));
    case 'LOGISTIC' %dC/dt = r C (1-C/K), K>0
      if usefn, x = user_functions(x,p(4:end),usrfn)-user_functions(zeros(size(x)),p(4:end),usrfn); end
      C  = p(1)*p(2)./(p(2)*exp(-p(3)*x)+p(1)*(1-exp(-p(3)*x)));
    case 'GOMPERTZ' %dC/dt = r C e^(-bt), b>0
      C  = p(1)*exp(p(3)*((1-exp(-p(2)*x))/p(2)));
    case 'RICHARDS' %dC/dt = r C [1-(C/K)^a], K>0, a>0
      if usefn, x = user_functions(x,p(5:end),usrfn)-user_functions(zeros(size(x)),p(5:end),usrfn); end
      C  = p(1)*p(2)./((p(2)^p(4))*exp(-p(3)*p(4)*x)+(p(1)^p(4))*(1-exp(-p(3)*p(4)*x))).^(1/p(4));
    case 'GENGOM'   %dC/dt = r C^p e^(-bt), b>0, 0<=p<1
      C  = ((1-p(4))*p(3)*((1-exp(-p(2)*x))/p(2))+p(1)^(1-p(4))).^(1/(1-p(4)));
    case 'GENLOG'   %dC/dt = r C^p (1-C/K), K>0, 0<=p<=1
      tt = x; if (x(1)>0), tt = [0; tt]; end
      [~,C] = ode23(@(t,y) p(3)*y^p(4)*(1-(y/p(2))),tt,p(1));
      if (x(1)>0), C=C(2:end); end
    case 'GENRIC'   %dC/dt = r C^p [1-(C/K)^a], K>0, 0<=p<=1, a>=0
      tt = x; if (x(1)>0), tt = [0; tt]; end
      [~,C] = ode23(@(t,y) p(3)*y^p(4)*(1-(y/p(2))^p(5)),tt,p(1));
      if (x(1)>0), C=C(2:end); end
    case 'SUB-WAVE' %dCi/dt = Ai r Ci^p [1-(Ci/Ki)^a] C=Sum(Ci,1,nsub), Ki=Ke^[-q(i-1)], Ai=Ci-1>=Cthr, K>0, 0<=p<=1, a>=0, q>=0, 1<Cthr<K
      Cthr = p(7)*data(1);
      nsub = sub_wave_nsub(Cthr,p,1e-6,length(x));
      C0=ones(nsub,1);  C0(1)=p(1);
      clear global A; global A=zeros(nsub,1); A(1)=1;
      tt = x; if (x(1)>0), tt = [0; tt]; end
      [~,Ci] = ode23(@(t,y) sub_wave_ode(t,y,p,Cthr,nsub),tt,C0);
      if (x(1)>0), Ci=Ci(2:end,:); end
      C=sum(Ci,2)-(nsub-1);
      %plot(x(2:end),diff(Ci),x(2:end),diff(C),'k-') %to plot subwaves
    case 'SIR' %Solves a single equation for C, instead of classical 3 (use NHM version with alpha=1 for classical version)
      tt = x; if (x(1)>0), tt = [0; tt]; end
      [~,C] = ode23(@(t,y) p(2)*(1-y/p(2))*(p(3)*y/p(2)+p(4)*log((1-y/p(2))/(1-p(1)))),tt,p(1)*p(2));
      if (x(1)>0), C=C(2:end); end
    case 'SIR-NHM'
      C0(1)=p(2)*(1-p(1)); C0(2)=p(1)*p(2); C0(3)=0;
      tt = x; if (x(1)>0), tt = [0; tt]; end
      [~,Ci] = ode23(@(t,y) sir_ode(t,y,p,usrfn),tt,C0);
      if (x(1)>0), Ci=Ci(2:end,:); end
      C=Ci(:,2)+Ci(:,3); %C=I+R
      %plot(x,Ci) %to plot all the variables
    case 'SEIR'
      C0(1)=p(2)*(1-p(1)); C0(2)=0; C0(3)=p(1)*p(2); C0(4)=0;
      tt = x; if (x(1)>0), tt = [0; tt]; end
      [~,Ci] = ode23(@(t,y) seir_ode(t,y,p,usrfn),tt,C0);
      if (x(1)>0), Ci=Ci(2:end,:); end
      C=Ci(:,3)+Ci(:,4); %C=I+R
      %plot(x,Ci) %to plot all the variables
    case 'SEmInR'
      m = data(1); n = data(2);
      C0 = zeros(m+n+2,1);
      C0(1)=p(2)*(1-p(1)); C0(m+2)=p(1)*p(2);
      tt = x; if (x(1)>0), tt = [0; tt]; end
      [~,Ci] = ode23(@(t,y) seminr_ode(t,y,p,m,n,usrfn),tt,C0);
      if (x(1)>0), Ci=Ci(2:end,:); end
      C=sum(Ci(:,m+2:m+n+2),2); %C=I+R
      %plot(x,Ci) %to plot all the variables
    otherwise
      error("Unrecognized model");
  end
  %If the daily data is required, instead of the cumulative ones
  if strcmp(dtype,"DAILY"), C=[C(1); diff(C)]; end
end
