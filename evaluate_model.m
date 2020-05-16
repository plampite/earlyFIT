function [f] = evaluate_model(t,beta,model,usrfn,data,dtype)
  %Driver function to evaluate the model for all the parameters' set in beta
  
  %Number of parameters' set
  n = size(beta,2);
  
  %Fix for models without data
  if (length(data)==0), data=zeros(1,n); end
  
  f = zeros(size(t,1),n);
  for i=1:n
    f(:,i) = growth_model(t,beta(:,i),model,usrfn,data(:,i),dtype);
  end
end
