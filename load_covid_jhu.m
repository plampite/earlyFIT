function [regions,t,a] = load_covid_jhu(vars,folder)
  %If input folder doesn't exist yet
  if !exist(folder,"dir"), mkdir(folder); end
  
  %Load region data from JHU github repository and write it to csv file or
  %read it straight from file if it alrady exists
  fname  = fullfile(folder,"jhu.csv");
  if !exist(fname,"file")
    string = urlread("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/web-data/data/cases_time.csv");
    fid    = fopen(fname, "w"); fputs(fid,string); fclose(fid);
  end
  
  %Convert csv file to cell array
  if is_octave
    c = csv2cell(fname);
  else
    error("Still have to workout the MATLAB version");
  end
  
  %See file header to choose other variables
  switch vars
    case "CASES"
      ind=3;
    case "DEATHS"
      ind=4;
    otherwise
      ind=3; %total cases as default
  end  
  %Reduce cell array to just the 2 required columns (and no header)
  c = c(2:end,[1,ind]);
  %Extract information from cell array
  regions = unique(c(:,1));
  nregion = size(regions,1);
  ndata   = size(c,1)/(nregion+58); %58 US regions to be discarded at the end of the file
  a       = zeros(ndata,nregion);
  %JHU file has data grouped by region (whose index, then, has to be the outer one)
  m=1;
  for j = 1:nregion
    for i = 1:ndata
      idx = find(strcmp(regions,c{m,1}));
      if (isempty(c{m,2}))
        a(i,idx)=a(i-1,idx); %for missing data (thanks France)
      else
        a(i,idx)=c{m,2};
      end
      m=m+1;
    end
  end
  
  %Times for the data series
  ts=1; %Start time of the series
  t=[ts:ts+size(a,1)-1]';
end
