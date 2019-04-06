n=500; a=linspace(0,2*pi,n/2)';
x=[a.*cos(a) a.*sin(a); (a+pi).*cos(a) (a+pi).*sin(a)];
x=x+rand(n,2); x=x-repmat(mean(x),[n,1]); x2=sum(x.^2,2);
y=[ones(1,n/2) zeros(1,n/2)];
d=repmat(x2,1,n)+repmat(x2',n,1)-2*x*x';

hhs=2*[0.5 1 2].^2; ls=10.^[-5 -4 -3]; m=5;
u=floor(m*[0:n-1]/n)+1; u=u(randperm(n));
g=zeros(length(hhs), length(ls),m);
for hk=1:length(hhs)
  hh=hhs(hk); k=exp(-d/hh);
  for j=unique(y), for i=1:m
    ki=k(u~=i,y==j); kc=k(u==i,y==j);
    Gi=ki'*ki*sum(u~=i&y==j)/(sum(u~=i)^2);
    Gc=kc'*kc*sum(u==i&y==j)/(sum(u==i)^2);
    hi=sum(k(u~=i&y==j,y==j),1)'/sum(u~=i);
    hc=sum(k(u==i&y==j,y==j),1)'/sum(u==i);
    for lk=1:length(ls)
      l=ls(lk); a=(Gi+l*eye(sum(y==j)))\hi;
      g(hk,lk,i)=g(hk,lk,i)+a'*Gc*a/2-hc'*a;
end, end, end, end
g=mean(g,3); [gl,ggl]=min(g,[],2); [ghl,gghl]=min(gl);
L=ls(ggl(gghl)); HH=hhs(gghl); s=-1/2;
for j=unique(y)
  k=exp(-d(:,y==j)/HH); h=sum(k(y==j,:),2)/n; t=sum(y==j);
  s=s+h'*((k'*k*t/(n^2)+L*eye(t))\h)/2;
end
disp(sprintf('Information=%g',s));