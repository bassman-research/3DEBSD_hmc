function [Red, Green, Blue] = colorPointRed(x, y)
%Version 1.0 Final Version
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

%%%Let us assume all points are in red region
length=numel(x);
Red     =ones(length,1);

AngV1    =ones(length,1)*theta;
AngV2    =ones(length,1)*atan((P2(2)-P6(2))/(P2(1)-P6(1)));
AngV3    =ones(length,1)*atan(P4(2)/(1-P4(1)));

%Now determine Blue index
AngBlue  =atan((P2(2)-y)./(P2(1)-x));
AngAxV12 =theta+AngV3;
AngV2xA  =pi-(AngBlue-theta)-AngAxV12;
RadialInt=.5*sin(AngAxV12)./sin(AngV2xA);
LBound   =[P2(1)-RadialInt.*cos(AngBlue), P2(2)-RadialInt.*sin(AngBlue)];

AngV2xV13=pi-(AngBlue-theta)-theta;
RadialInt=sin(AngV1)./sin(AngV2xV13);
UBound   =[P2(1)-RadialInt.*cos(AngBlue), P2(2)-RadialInt.*sin(AngBlue)];
IndexL   =distance2(LBound, UBound);
IndexD   =distance2([x y], LBound);
Blue      =1-IndexD./IndexL;
Blue=abs(Blue);
% hold on
% plot(UBound(:,1), UBound(:,2),'*b')
% hold on
% plot(LBound(:,1), LBound(:,2),'*b')

%Now Determine green index
AngGreen = atan(y./(1-x));
AngV3xC  = pi-AngGreen-AngV2;
RadialInt= .5*sin(AngV2)./sin(AngV3xC);
LBound   =[1-RadialInt.*cos(AngGreen), RadialInt.*sin(AngGreen)];

AngV3xV12  = pi-AngGreen-AngV1;
RadialInt= sin(AngV1)./sin(AngV3xV12);
UBound   =[1-RadialInt.*cos(AngGreen), RadialInt.*sin(AngGreen)];

IndexL   =distance2(LBound, UBound);
IndexD   =distance2([x y], LBound);
Green    =1-IndexD./IndexL;
Green    =abs(Green);
for i=1:numel(Green)
    if Green(i)>1||Green(i)<0
        Green(i)
    end
end
% hold on
% plot(UBound(:,1), UBound(:,2),'*g')
% hold on
% plot(LBound(:,1), LBound(:,2),'*g')
