function [labels,t,y] = load_data(vars,reg,source,folder)
  %Loads data from one of a series of possible sources
  %Data must be cumulative, fitting on daily cases is managed separately
  %label0 is used to replace when reg="ALL" in input, because it is used in plots
  
  switch source
    case "COVIDITA" %Italy COVID-19 data from the PCM-DPC github repository
      [labels,t,y] = load_covid_ita(vars,folder);
      label0 = "Italy";
    case "COVIDJHU" %World COVID-19 data from the JHU github repository
      [labels,t,y] = load_covid_jhu(vars,folder);
      label0 = "World";
    otherwise
      %We try to load a file with the name as your source from the input folder
      %File must be ASCII, with n+1 rows and m+1 columns:
      % - first row is header, remaining ones are data
      % - first column are times, remaining ones are data
      % - each column a region, with its name in the first row (header) 
      if (!exist(folder,"dir")), error(strcat("Input folder",[" " folder]," is missing")); end
      fname = fullfile(folder,source);
      if exist(fname,"file")
        d = importdata(fname,' ',1);
        labels = d.colheaders(2:end)';
        t      = d.data(:,1);
        y      = d.data(:,2:end);
      else
        error(strcat("Input file",[" " fname]," does not exist"));
      end
      label0 = "Mydata";
  end

  %""    -> take all the regions as separate
  %"ALL" -> take all the regions as summed in one
  %"XYZ" -> take region "XYZ" if available, otherwise revert to "ALL"
  if (!strcmp(reg,""))
    if (strcmp(reg,"ALL") || !any(strcmp(reg,labels)))
      %The input region doesn't exist or you asked for "ALL"
      y=sum(y,2);
      labels={label0};
    else
        %The input region exists and you get it alone
        idx=find(strcmp(reg,labels));
        y=y(:,idx);
        labels=labels(idx);
    end
  end
end
