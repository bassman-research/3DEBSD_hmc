function [Red, Green, Blue] = colorPointBlue(x, y)
%Version 1.0

%Note this program uses vectorized inputs and outputs for speed
%   optimization

%colorPointRed/Blue/Green are a set of programs that partition an IPF and
%   create a colormap based on the edax Coloring. Vertices of the IPF are
%   considered as vertices of a triangle.
%V1 = [100]
%V2 = [111]
%V3 = [110]
%A B C are lines from each vertice to the midpoint of the opposite side. 
%I recommend pencil and paper to follow this program

%Note Theta, and points 1-6 are not arbitrary, but determined from the
%great circles generally used in creating IPFs. This colormap scheme works
%by using the intersection of the steroegraphic projection of a pole
%through a particular great circle 

theta=acos(dot([1/sqrt(2) 0 1/sqrt(2)], [1/sqrt(3), 1/sqrt(3), 1/sqrt(3)]));

%Define the Arc Region of Colorspace
P1=[0, 0];
P2=[cos(theta), sin(theta)];
P3=[1, 0];
P4=[.5*cos(theta), .5*sin(theta)];
P5=[cos(theta/2), sin(theta/2)];
P6=[.5, 0]; 


%%%Let us assume all points are in blue region
length=numel(x);
Blue     =ones(length,1);

AngV3 =ones(length,1)*atan(P4(2)/(1-P4(1)));
AngV1L=ones(length,1)*theta/2;
AngV1H=ones(length,1)*theta;

%Now determine red index
AngRed   =atan(y./x);
AngV1xA  =pi-AngRed-AngV3;
RadialInt=sin(AngV3)./sin(AngV1xA);
size(RadialInt);
size(AngRed);

UBound   =[cos(AngRed), sin(AngRed)];
LBound   =[RadialInt.*cos(AngRed), RadialInt.*sin(AngRed)];
IndexL   =distance2(LBound, UBound);
IndexD   =distance2([x y], LBound);
Red      =1-IndexD./IndexL;

% hold on
% plot(UBound(:,1), UBound(:,2),'*r')
% hold on
% plot(LBound(:,1), LBound(:,2),'*r')


%Now Determine green index
AngGreen = atan(y./(1-x));
AngV3xB  = pi-AngGreen-AngV1L;
RadialInt= sin(AngV1L)./sin(AngV3xB);
LBound   =[1-RadialInt.*cos(AngGreen), RadialInt.*sin(AngGreen)];

AngV3xV12= pi-AngGreen-AngV1H;
RadialInt= sin(AngV1H)./sin(AngV3xV12);
UBound   =[1-RadialInt.*cos(AngGreen), RadialInt.*sin(AngGreen)];

IndexL   =distance2(LBound, UBound);
IndexD   =distance2([x y], LBound);
Green    =1-IndexD./IndexL;

for i=1:numel(Green)
    if Green(i)>1||Green(i)<0
        Green(i)=0;
        2;
    end
end

% hold on
% plot(UBound(:,1), UBound(:,2),'*g')
% hold on
% plot(LBound(:,1), LBound(:,2),'*b')



