function ei = evaluate_boots(te,betai,model,usrfn,data,dtype)
  [np,M,nreg] = size(betai);

  ne = length(te); 
  ei = zeros(ne,M,nreg);

  for i=1:M
    ei(:,i,:) = reshape(evaluate_model(te,squeeze(betai(:,i,:)),model,usrfn,data,dtype),ne,1,nreg);
  end
end