function [f] = user_functions(x,p,usrfn,varargin)
  %Evaluates the user function usrfn with parameters p at x
  
  switch usrfn
    case 'LIN'
      f  = p(1)+p(2)*x;
    case 'GOM'
      f = min(x,p(1))+(exp(-p(2)*p(1))-exp(-p(2)*max(p(1),x)))/p(2);
    case 'BETADECAY'
      f = (p(1)+(1-p(1))*exp(-p(2)*max(x-p(3),0)));
    case 'BETAEXP'
      y = varargin{1};
      f = exp(-p(1)*y);
    case 'BETARAT'
      y = varargin{1};
      f = 1/(1+p(1)*y);
    case 'BETASIN'
      y = varargin{1};
      f = (1+p(1)*sin(2*pi*(p(2)*x+p(3))))/(1+p(4)*y);
    otherwise
      error("Unrecognized user function");
  end
end