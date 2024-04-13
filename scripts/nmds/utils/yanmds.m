function [X,spread,info,B,slack,raw,A,b,c,K] = yanmds(Xi,n,lambda)
% function [X,spread,info] = learn_embedding(Xi,n,lambda,d,solver)
% Xi : relative comparisons [p,q,r,s] d_pq < d_rs
% n : number of points
% lambda : regularization parameter 
%
%
% X is a matrix with each row corresponding to embedding coordinates. 
%  spread is a matrix indicating the variance along each embedding
%  dimension (column of X)
  
  fprintf('Generalized Nonmetric Multidimensional Scaling\n');

  % initialize variables
  X = []; spread  = []; info = 0;

  [A,b,c,K] = gen_sdp(n,Xi,lambda);
	[x,y,info] = sedumi(A,b,c,K);
  retval = (info.numerr <= 1)&(info.dinf == 0);

	if ~retval;
		error('solver error');
	else;
		slack = sum(y(n*n+1:n*n+size(Xi,1)));
    B=reshape(y(1:n*n),n,n);
    B=(B+B')/2; 
    [U1,S1,V1]=svd(B);
    
    X = U1*sqrt(S1);
    spread = diag(S1);
  end

return
