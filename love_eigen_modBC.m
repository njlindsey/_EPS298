clear all;
close all;
%Script to compute the Love Wave l1 and l2 eigenfunctions

nyquist=1.0;
numfreq=64;
df=nyquist/numfreq;

vel=[4 2.4 2.0; 25 3.5 2.67; 100 4.5 3.3];
[numlay, numel]=size(vel);

w=2*pi.*[df:df:nyquist];
% w=2*pi.*[0.5:0.1:1.0];
cmin=min(vel(:,2))*100000;
cmax=max(vel(:,2))*100000;


mu=(vel(:,2).*100000).^2.*vel(:,3);

z=vel(1,1)*(100000);
for h=1:length(w)
    kmax=w(h)/cmin;
    kmin=w(h)/cmax;
    k=0:kmin/1000:kmax;
for i=1:length(k)
    
    nnu=sqrt(k(i)^2-(w(h)./(vel(:,2).*100000)).^2);
    
    if (real(nnu(1) < 0.0))
        nnu(1)=nnu(1)*-1;
        disp('f')
    end
    if (real(nnu(2) < 0.0))
        nnu(2)=nnu(2)*-1;
        disp('f')
    end
    
    %disp(nnu)
    
    F=(1/(2*nnu(2)*mu(2))).*[nnu(2)*mu(2)*exp(nnu(2)*z) -1*exp(nnu(2)*z); nnu(2)*mu(2)*exp(-1*nnu(2)*z) exp(-1*nnu(2)*z)];
    %disp(F)
    P=[cosh(nnu(1)*z) 1/(nnu(1)*mu(1))*sinh(nnu(1)*z); nnu(1)*mu(1)*sinh(nnu(1)*z) cosh(nnu(1)*z)];
    disp(P)
    B=F*P;
    disp(B)
    

    b21(i)=real(B(2,1));
    ib21(i)=imag(B(2,1))
    
end

j=find(ib21 == 0)

a=b21(j)';
disp(a)
% size(a);
threshold=0.01;
% [v,l]=min(abs(a));
l=find(abs(a) < 0.01);

kk(h)=max(k(j(l)));
% kk(h)=k(j(l))
c(h)=w(h)/kk(h);

end

figure;
plot(w./2./pi,kk);
title('wavenumber k vs w');
figure;
plot(1./(w./2./pi),c)
title('phase velocity vs f');

disp(kk(10))
disp(w(10))

z=[0:1.:40].*100000;
for i=1:length(z)
    nnu=sqrt(kk(10)^2-(w(10)./(vel(:,2).*100000)).^2);

    disp(i)
    if (z(i) <= vel(1,1)*100000)
        disp('in first layer')
        P=[cosh(nnu(1)*z(i)) 1/(nnu(1)*mu(1))*sinh(nnu(1)*z(i)); nnu(1)*mu(1)*sinh(nnu(1)*z(i)) cosh(nnu(1)*z(i))];
        P
    end
    if (z(i) > vel(1,1)*100000)
        disp('in second layer')
        z0=vel(1,1)*100000;
        P1=[cosh(nnu(2)*(z(i)-z0)) 1/(nnu(2)*mu(2))*sinh(nnu(2)*(z(i)-z0)); nnu(2)*mu(2)*sinh(nnu(2)*(z(i)-z0)) cosh(nnu(2)*(z(i)-z0))];
        P=P1*[cosh(nnu(1)*z0) 1/(nnu(1)*mu(1))*sinh(nnu(1)*z0); nnu(1)*mu(1)*sinh(nnu(1)*z0) cosh(nnu(1)*z0)];
        P
    end
    
    f=P*[1; 0];
    disp(f)
    l1(i)=f(1);
    l2(i)=f(2);
    
end

figure;
plot(z,l1);
title('l1 vs z');
figure;
plot(z,l2);
title ('l2 vs z');

