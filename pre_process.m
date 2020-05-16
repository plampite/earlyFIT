function [lab,t,y] = pre_process(t0,y0,mode,p,labels)
  [nt,nreg] = size(y0);
  lab = labels;
  switch mode
    case "CUT" %only data from t(p(1)) to t(p(2))
      is = max(1,p(1));
      ie = min(nt,p(2));
      t  = t0(is:ie);
      y  = y0(is:ie,:);
    case "EXC" %only regions whose index is not in p
      list = unique(p(p>=1&p<=nreg));
      n    = length(list);
      t    = t0;
      lab  = cell(nreg-n,1);
      y    = zeros(nt,nreg-n);
      m=1;
      for i = 1:nreg
        if any(i==list), continue, end
        y(:,m)   = y0(:,i);
        lab{m,1} = labels{i};
        m = m+1;
      end
    case "SAM" %sample every p data
      np=p(1);
      if np<nt/3 %we want at least 3 time points in the final data
        m = mod(nt,np);
        n = (nt-m)/np;
        s = n+(m>0);
        t = zeros(s,1);
        y = zeros(s,nreg);
        for i = nt:-np:1
          t(s)   = t0(i);
          y(s,:) = y0(i,:);
          s=s-1;
        end
      else
        %Do nothing
        t=t0;
        y=y0;        
      end
    case "ABO" %only regions with final total number above p
      t = t0;
      y = y0(:,y0(end,:)>p(1));
      if (isempty(y))
        y = y0;
      else
        lab=labels(y0(end,:)>p(1));
      end
    case "STA" %time starts when the total number is above p
      if (nreg==1)
        y=y0(y0>p(1));
        if (isempty(y))
          t=t0;
          y=y0;
        else
          t=t0(end-numel(y)+1:end);
          t=t-t(1)+1;
        end
      else
        %Only for a single region
        t=t0;
        y=y0;
      end
    otherwise
      %Do nothing
      t=t0;
      y=y0;
  end
end
