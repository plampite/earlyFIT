function [beta] = richards_guess(yi,yj,yk,dt,a)
  %Guess of Richards curve parameters given 3 equispaced values dt apart and a
  %i>j>k
  beta = [];
  if (a>0 && dt>0)
    num = yi^a*(yj^a-yk^a);
    den = yk^a*(yi^a-yj^a);
    if (num>0 && den>0 && num>den && num^2>den^2*(yi/yk)^a)
      r  = log(num/den)/dt;
      d  = yk^a*(num/den)-yi^a*(den/num);
      K  = yi*yk*((num/den-den/num)/d)^(1/a);
      Q  = (yi^a-yk^a)/d;
      C0 = K/(1+Q)^(1/a);
      beta = [C0;K;r;a];
    end
  end
endfunction
