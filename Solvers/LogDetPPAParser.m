function[X,runhist] = LogDetPPAParser(Sigma,p,q,rho,beta,gamma2)



% here is the start of it    

      m = (p+q)*(p+q+1)/2 - (q)*(q+1)/2;
      n = p+q;
      nyy = p;
      [M1 M2] = ObtainMatrices_nucNorm(p,q,m); 
      blk{1,1} = 's'; blk{1,2} = (p+q);
      C{1,1} = Sigma;
      At{1,1} = sparse(M1); 
      
      %% this is the Lyy block

      blk{2,1} = 's'; blk{2,2} = p;
      
      for k = 1:p*(p+1)/2
          Temp2(k,:) = [k k 1];
      end
  
      Temp2(p*(p+1)/2+1,:) = [p*(p+1)/2 m 0];
    
      Atmp = spconvert(Temp2);
      At{2,1}  = Atmp; 
      C{2,1}   = beta*speye(p,p); 
      
      
         %% this is the delta block
       
      blk{3,1} = 's'; blk{3,2} = p+q;
      At{3,1}  = sparse(M2); 
      C{3,1}   = gamma2*speye(n,n); 
      
      %%
      blk{4,1} = 'l'; blk{4,2} = 2*nyy*(nyy+1)/2;  
      for k = 1:nyy*(nyy+1)/2
          Temp4(k,:) = [k k 1];
      end
      Temp4(nyy*(nyy+1)/2+1,:) = [m nyy*(nyy+1)/2 0];
      
      At{4,1} = [-spconvert(Temp4) spconvert(Temp4)]';
     
      [Iall,Jall] = find(triu(ones(nyy)));
      tmp = [Iall,Jall]; 
      m2 = size(tmp,1); 
      Icomp = tmp(:,1); Jcomp = tmp(:,2);
      Itmp  = Icomp + Jcomp.*(Jcomp-1)/2; 
      idx = find(Icomp == Jcomp); 
      ee  = sqrt(2)*ones(nyy*(nyy+1)/2,1); 
      if ~isempty(idx); ee(idx) = ones(length(idx),1); end
      C{4,1} = rho*[ee; ee];
      
      
      
      b = zeros(m,1);
      runPPA = 1; 
      if (runPPA)
         OPTIONS.smoothing  = 1;
         OPTIONS.scale_data = 0; %% or 2;
         OPTIONS.plotyes    = 0; 
         OPTIONS.tol        = 1e-6;
         mu = [1; 0; 0;0];
         [obj,X,y,Z] = logdetPPA(blk,At,C,b,mu,OPTIONS);
         
      end

  % How to check to see how accurate our model is 