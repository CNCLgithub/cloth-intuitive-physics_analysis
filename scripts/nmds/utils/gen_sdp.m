function [A,b,c,K]=gen_sdp(npts,Xi,lambda);
% function [A,b,c,K]=gen_linear_problem(X,Xi,lambda,opts);
% this is the purely linear version
% also the form of the optimization is 
% slack + lambda*regularizer
   
  if nargin < 3;
    error('Error: Not enough arguments');
  end
  
  n1 = npts; n2 = npts; n = size(Xi,1);
    
  % B  delta
  nvar = n2*n2 + n + 1 + 1;
  start_a = n2*n2;
  
  
  A = sparse(0,nvar); c = sparse(0,1); b = sparse(nvar,1);
  
  BB = speye(n2);
  % normalize the error thing
  b(1:n2*n2) = -lambda*BB(:)/npts;
  
  if size(Xi,2) == 3;
    b(start_a+1:start_a + n) = -1;
  else
    b(start_a+1:start_a + n) = -Xi(:,end);
  end

  
  %normalize the error thing
  b(start_a+1:start_a+n) =   b(start_a+1:start_a+n)/sum(abs(b(start_a+1:start_a+n)));
  
  A(1,1:n2*n2) = 1;
  c(1,1) = 0;
  K.f = 1 ; % centering
  
  totalel = n*(2+8);
  
  I = zeros(totalel,1); J = zeros(totalel,1); S  = zeros(totalel,1);
  
  ctmp = sparse(2*n,1);
  
  counter = 1;
  for i = 1:n;
    
    dpos = start_a+i;
           
    %Cpqrs = d_rs - d_pq > 1 - delta_pqrs
    % pp + qq - pq - qp - rr - ss + rs + sr
    if size(Xi,2) == 5;
      p = Xi(i,1); q = Xi(i,2); r = Xi(i,3); s = Xi(i,4);
    else
      p = Xi(i,1); q = Xi(i,2); r = q; s = Xi(i,3);
    end
    
    I(counter:counter+7,1) = i;
    
    
    J(counter:counter+7,1) = [mysub2ind([npts,npts],r,r);
		    mysub2ind([npts,npts],s,s);
		    mysub2ind([npts,npts],r,s);
		    mysub2ind([npts,npts],s,r);
		    mysub2ind([npts,npts],p,p);
		    mysub2ind([npts,npts],q,q);
		    mysub2ind([npts,npts],q,p);
		    mysub2ind([npts,npts],p,q);
		   ];

    S(counter:counter+7,1) = -[1,1,-1,-1,-1,-1,1,1]';
    
    counter = counter+8;
    
    I(counter,1) = i;
    J(counter,1) = dpos;
    S(counter,1) = -1;
    counter = counter+1;
    
    ctmp(i,1) = -1;
  end
  
  for i = 1:n;
    dpos = start_a+i;
    I(counter,1) = n+i;
    J(counter,1) = dpos;
    S(counter,1) = -1;
    counter = counter+1;   
  end;
  
  if (counter > totalel+1)
    fprintf('error\n');
  end

  A = [A;sparse(I,J,S,2*n,nvar)];
  c = [c;ctmp];
  K.l = 2*n;
      
  A=[A;[-speye(npts*npts),sparse(npts*npts,nvar-npts*npts)]]; 
  c=[c;sparse(npts*npts,1)];

  K.s = npts;
  return;

function value  = mysub2ind(a,b,c);
  value = (c-1)*a(1) + b;
	return;