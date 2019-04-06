n=300; x=randn(n,1); y=randn(n,1)+0.5;
hhs=2*[1 5 10].^2; ls=10.^[-3 -2 -1]; m=5; b=0.5;
x2=x.^2; xx=repmat(x2,1,n)+repmat(x2',n,1)-2*x*x';
y2=y.^2; yx=repmat(y2,1,n)+repmat(x2',n,1)-2*y*x';
u=floor(m*[0:n-1]/n)+1; u=u(randperm(n));
v=floor(m*[0:n-1]/n)+1; v=v(randperm(n));

g=zeros(length(hhs),length(ls),m);
for hk=1:length(hhs)
  hh=hhs(hk); k=exp(-xx/hh); r=exp(-yx/hh);
  for i=1:m
    ki=k(u~=i,:); ri=r(v~=i,:); h=mean(ki)';
    kc=k(u==i,:); rj =r(v==i,:);
    G=b*ki'*ki/sum(u~=i)+(1-b)*ri'*ri/sum(v~=i);
    for lk=1:length(ls)
      l=ls(lk); a=(G+l*eye(n))\h; kca=kc*a;
      g(hk,lk,i)=b*mean(kca.^2)+(1-b)*mean((rj*a).^2);
      g(hk,lk,i)=g(hk,lk,i)/2-mean(kca);
end, end, end
[gl,ggl]=min(mean(g,3),[],2); [ghl,gghl]=min(gl);
L=ls(ggl(gghl)); HH=hhs(gghl);
k=exp(-xx/HH); r=exp(-yx/HH);
s=r*((b*k'*k/n+(1-b)*r'*r/n+L*eye(n))\(mean(k)'));

figure(1); clf; hold on; plot(y,s,'rx');