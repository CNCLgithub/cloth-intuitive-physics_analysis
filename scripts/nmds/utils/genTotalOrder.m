function Xi=genTotalOrder(D)

  [npts,blah]=size(D);
  [Y,Ind]=sort(D(:));
  [ist,jst]=ind2sub([npts npts],Ind);
  is=zeros(npts*(npts-1)/2,1);
  js=zeros(npts*(npts-1)/2,1);
  count2=1;
  for count=1:npts*npts,
    if(ist(count)<jst(count)) %ignore dupes
      is(count2)=ist(count);
      js(count2)=jst(count);
      count2=count2+1;
    end
  end

  Xi=ones(size(is,1)-1,5);
  for count=1:(size(is)-1)
    Xi(count,[1:4])=[is(count),js(count),is(count+1),js(count+1)];
  end
  
