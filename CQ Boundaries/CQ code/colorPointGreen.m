function [Red, Green, Blue] = colorPointGreen(x, y)
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

%%%Let us assume all points are in green region
length=numel(x);
Green     =ones(length,1);

AngV1    =ones(length,1)*theta;
AngV2    =ones(length,1)*atan((P2(2)-P6(2))/(P2(1)-P6(1)));
AngV3    =ones(length,1)*atan(P4(2)/(1-P4(1)));

%Now determine Blue index
AngBlue  =atan((P2(2)-y)./(P2(1)-x));
AngBlue2 =AngBlue + (pi).*(AngBlue<0);
AngV2xA  =pi-(AngBlue2-theta)-AngV1/2;
RadialInt=sin(AngBlue2-theta)./sin(AngV2xA);
LBound   =[RadialInt.*cos(AngV1/2), RadialInt.*sin(AngV1/2)];

AngV2xV13=pi-(AngBlue-theta)-theta;
RadialInt=sin(AngV1)./sin(AngV2xV13);
UBound   =[P2(1)-RadialInt.*cos(AngBlue), P2(2)-RadialInt.*sin(AngBlue)];
IndexL   =distance2(LBound, UBound);
IndexD   =distance2([x y], LBound);
Blue      =1-IndexD./IndexL;
Blue=abs(Blue);

%Now Determine red index
AngRed    = atan(y./x);
AngCxV12  = pi-AngV2;
AngV1xC   = pi-AngRed-AngCxV12;
RadialInt = .5*sin(AngCxV12)./sin(AngV1xC);
LBound    =[RadialInt.*cos(AngRed), RadialInt.*sin(AngRed)];

UBound   =[cos(AngRed), sin(AngRed)];
IndexL   =distance2(LBound, UBound);
IndexD   =distance2([x y], LBound);
Red      =1-IndexD./IndexL;
Red      =abs(Red);
