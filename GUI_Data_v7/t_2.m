T = zeros (1, 1001);
T1 = zeros (1, 1001);
T(1)=1;
T1(1)=0.1;

for i=1:1000
    T(i+1) = T(i) + 0.01*T1(i);
    T1(i+1)= T1(i) + 0.01.*((-0.1*T1(i))- sin(T(i)));
end
A1= [T; T1];

n=1001;
t=linspace(1,10,n);
y=A1;

h=t(2)-t(1);

% Trapezoidal rule
TotalArea(1)=0;
for j=1:n-1
  A=h*(y(j)+y(j+1))/2;   
  TotalArea(j+1)=A+TotalArea(j);
end

A2=TotalArea

z = simps(A1);

% Simposon's rule
TotalAreaS(1)=0; count=1;
for j=1:2:n-2
  A=h*(y(j)+4*y(j+1)+y(j+2))/3;   
  TotalAreaS(count+1)=A+TotalAreaS(count);
  count=count+1;
end
A3=TotalAreaS

dx=0.01;
x=0:dx:10;
n=length(x);


% second-order center, forward, backward
yp(1)= (-3*y(1)+4*y(2)-y(3))/(2*dx);

for j=2:n-1
   yp(j)=( y(j+1)-y(j-1) )/(2*dx);
end

yp(n)= (3*y(n)-4*y(n-1)+y(n-2))/(2*dx);

A4=yp;

%fourth-order center, second forward, backward
yt(1)= (-3*y(1)+4*y(2)-y(3))/(2*dx);
yt(2)= (-3*y(2) + 4*y(3) -y(4)) / (2*dx);

for j=3:n-2
   yt(j)=(-1*y(j+2)+8*y(j+1)-8*y(j-1)+ y(j-2) )/(12*dx);
end

yt(n)= (3*y(n)-4*y(n-1)+y(n-2))/(2*dx);
yt(n-1) = (3*y(n-1) - 4*y(n-2)+y(n-3)) / (2*dx);
A5=yt;
