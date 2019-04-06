n=100; x=randn(n,2);
x(1:n/2,1)=x(1:n/2,1)-4; x(n/2+1:end,1)=x(n/2+1:end,1)+4;
%x(1:n/4,1)=x(1:n/4,1)-4; x(n/4+1:n/2,1)=x(n/4+1:n/2,1)+4;
x=x-repmat(mean(x),[n,1]); y=[ones(n/2,1); 2*ones(n/2,1)];

Sw=zeros(2,2); Sb=zeros(2,2);
for j=1:2
  p=x(y==j,:); p1=sum(p); p2=sum(p.^2,2); nj=sum(y==j);
  W=exp(-(repmat(p2,1,nj)+repmat(p2',nj,1)-2*p*p'));
  G=p'*(repmat(sum(W,2),[1 2]).*p)-p'*W*p;
  Sb=Sb+G/n+p'*p*(1-nj/n)+p1'*p1/n; Sw=Sw+G/nj;
end
[t,v]=eigs((Sb+Sb')/2,(Sw+Sw')/2,1);

figure(1); clf; hold on; axis( [-8 8 -6 6])
plot(x(y==1,1),x(y==1,2),' bo')
plot(x(y==2,1),x(y==2,2),'rx')
plot(99*[-t(1) t(1)],99*[-t(2) t(2)],'k-')