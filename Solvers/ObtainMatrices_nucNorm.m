function [FinalVec, FinalVec3] = ObtainMatrices_nucNorm(p,q,m)

n = p+q;

% the first matrix is for creating Omega_yy, Omega_yx
FinalVec = zeros(n*(n+1)/2,m);
FinalVec(1:p*(p+1)/2,1:p*(p+1)/2) = eye(p*(p+1)/2);

begc = p*(p+1)/2+1;
begr = p*(p+1)/2+1;
enr = begr+p-1;
enc = begc+p-1;

for i = 1:q
    FinalVec(begr:enr,begc:enc)= eye(p);
    begc = enc+1;
    begr = enr+i+1;
    enr = begr+p-1;
enc = begc+p-1;
end




FinalVec3 = zeros((p+q)*(p+q+1)/2,m);
begc = p*(p+1)/2+1;
begr = p*(p+1)/2+1;
enr = begr+p-1;
enc = begc+p-1;

for i = 1:q
    FinalVec3(begr:enr,begc:enc)= -eye(p);
    begc = enc+1;
    begr = enr+i+1;
    enr = begr+p-1;
enc = begc+p-1;
end





% 
% begc = 1;
% begr = 1;
% endr = p;
% endc = p;
% for j = 0:p-1
%     FinalVec(begr:endr,begc:endc) = eye(p-j);
%     begr = endr + 1 + q;
%     endr = begr + p-(j+1)-1;
%     begc = endc + 1;
%     endc = begc + p-(j+1)-1;
% end
% 
% begr = p + 1;
% endr = p+1+q-1;
% begc = endc+1;
% endc = begc + q-1;
% for j = 0:p-1
% 
%     FinalVec(begr:endr,begc:endc) = eye(q);
%     begr = endr+(p-(j+1))+1;
%     endr = begr + (q-1);
%     begc = endc + 1;
%     endc = begc + (q-1);
% end
% 
% FinalVec(1,1) = 1;
% 
% % Corresponds to Delta matrix
% FinalVec3 = zeros((p+q)*(p+q+1)/2,m);
% s2 = p*(p+1)/2;
% % the first p*(p+1)/2 columns are zero
% begcs = s2; 
% 
% 
% 
% % need to figure out where this starts
% % lyx stuff
% begr = p+1;
% begc = begcs+1;
% for i = 1:p
%     enc = begc+q-1;
%     FinalVec3(begr:begr+q-1,begc:enc) = -eye(q);
%     begr = begr + q-1+p-i+1;
%     begc = enc+1;
% end
%     
%     
    
    
        
    



