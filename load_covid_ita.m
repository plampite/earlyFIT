function [regions,t,a] = load_covid_ita(vars,folder)
  %If input folder doesn't exist yet
  if !exist(folder,"dir"), mkdir(folder); end
  
  %Load region data from PCM-DPC github repository and write it to csv file or
  %read it straight from file if it alrady exists
  fname  = fullfile(folder,"ita.csv");
  if !exist(fname,"file")
    string = urlread("https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-regioni/dpc-covid19-ita-regioni.csv");
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
    case "OSP" 
      ind=7;
    case "ICU" 
      ind=8;
    case "OSPTOT"
      ind=9;
    case "CASES"
      ind=16;
    case "DEATHS"
      ind=15;
    case "TAMPONS"
      ind=17;
    otherwise
      ind=16; %total cases as default
  end
  
  %Reduce cell array to just the 2 required columns (and no header)
  c = c(2:end,[4,ind]);
  
  %Extract information from cell array
  regions = unique(c(:,1));
  nregion = size(regions,1);
  ndata   = size(c,1)/nregion;
  a       = zeros(ndata,nregion);
  
  %PCM-PC file has data grouped by date (whose index, then, has to be the outer one)
  m=1;
  for i = 1:ndata
    for j = 1:nregion
      idx = find(strcmp(regions,c{m,1}));
      a(i,idx)=c{m,2};
      m=m+1;
    end
  end
  
  %Times for the data series
  ts=1; %Start time of the series
  t=[ts:ts+size(a,1)-1]';
end
