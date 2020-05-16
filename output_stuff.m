function output_stuff(labels,x,y,f,fl,fu,t,e,el,eu,folder)
  %If output folder doesn't exist yet
  if !exist(folder,"dir"), mkdir(folder); end
  
  %How many dataset we need to plot
  n = size(y,2);

  %Loop over the dataset  
  for i=1:n
    %The prefix to filenames of the plots to be saved
    prefix=strcat(fullfile(folder,labels{i}),'_');
    
    %Plot the pdf of the error of the current fit (only the mean)
    figure()
    hist(y(:,i)-f(:,i),20)
    xlabel('E')
    ylabel('PDF(E)')
    title(labels{i})
    print(gcf,"-dpng","-color","-r0",strcat(prefix,'error.png'))
    
    %Plot of total number
    figure()
    plot(x,y(:,i),'k.',x,f(:,i) ,'r-' ,t,e(:,i) ,'b-' ,...
                       x,fl(:,i),'r--',x,fu(:,i),'r--',...
                       t,el(:,i),'b--',t,eu(:,i),'b--')
    xlabel('Days since outbreak')
    ylabel('Total N.')
    legend('Current data','Fit','Extrapolation','Location','NorthWest')
    grid on
    title(labels{i})
    print(gcf,"-dpng","-color","-r0",strcat(prefix,'total.png'))
    
    %Plot of total number in log scale
    figure()
    semilogy(x,y(:,i),'k.',x,f(:,i) ,'r-' ,t,e(:,i) ,'b-' ,...
                           x,fl(:,i),'r--',x,fu(:,i),'r--',...
                           t,el(:,i),'b--',t,eu(:,i),'b--')
    xlabel('Days since outbreak')
    ylabel('Total N.')
    legend('Current data','Fit','Extrapolation','Location','SouthEast')
    grid on
    title(labels{i})
    print(gcf,"-dpng","-color","-r0",strcat(prefix,'total_log.png'))
    
    %Plot of daily increase in total number
    figure()
    plot(x(2:end),diff(y(:,i)),'k.',x(2:end),diff(f(:,i)) ,'r-' ,t(2:end),diff(e(:,i)) ,'b-' ,...
                                    x(2:end),diff(fl(:,i)),'r--',x(2:end),diff(fu(:,i)),'r--',...
                                    t(2:end),diff(el(:,i)),'b--',t(2:end),diff(eu(:,i)),'b--')
    xlabel('Days since outbreak')
    ylabel('Daily N.')
    legend('Current data','Fit','Extrapolation','Location','NorthEast')
    grid on
    title(labels{i})
    print(gcf,"-dpng","-color","-r0",strcat(prefix,'daily.png'))
    
    %Plot of % daily increase of total number
    figure()
    plot(x(2:end),100*diff(y(:,i))./y(1:end-1,i)  ,'k.' ,...
         x(2:end),100*diff(f(:,i))./f(1:end-1,i)  ,'r-' ,...
         t(2:end),100*diff(e(:,i))./e(1:end-1,i)  ,'b-' ,...
         x(2:end),100*diff(fl(:,i))./fl(1:end-1,i),'r--',...
         x(2:end),100*diff(fu(:,i))./fu(1:end-1,i),'r--',...
         t(2:end),100*diff(el(:,i))./el(1:end-1,i),'b--',...
         t(2:end),100*diff(eu(:,i))./eu(1:end-1,i),'b--')
    xlabel('Days since outbreak')
    ylabel('Daily % increase')
    ylim([0 100])
    legend('Current data','Fit','Extrapolation','Location','NorthEast')
    grid on
    title(labels{i})
    print(gcf,"-dpng","-color","-r0",strcat(prefix,'percinc.png'))
  end
end
