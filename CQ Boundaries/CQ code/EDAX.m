%EDAX takes a set of information representing IPF data
%   Points are represented by their polar cordinate of
%   radius theta as well as their position in the image (IMx, IMy)

function [Red, Green, Blue, posX, posY] = EDAX(Rad, Th, IMx, IMy)
    theta= acos(dot([1/sqrt(2) 0 1/sqrt(2)], [1/sqrt(3), 1/sqrt(3), 1/sqrt(3)]));
    
    %General Parameters of IPF
    %P1-3 are vertices of triangle
    %P4-6 are midpoints of each side
    P1=[0, 0];
    P2=[cos(theta), sin(theta)];
    P3=[1, 0];
    P4=[.5*cos(theta), .5*sin(theta)];
    P5=[cos(theta/2), sin(theta/2)];
    P6=[.5, 0]; %#ok<NASGU>

    %Find the slope for lines intersecting a midpoint and opposite triangle
    %vertice
    n=sin(theta)/(cos(theta)-.5);
    m=.5*sin(theta)/(.5*cos(theta)-1);
    p=sin(theta/2)/(cos(theta/2));
    
    %Intialize region indexes and matrices
    B=1;
    R=1;
    G=1;
    lines=length(Rad);
    PointsB=zeros(lines+1, 3);
    PointsR=zeros(lines+1, 3);
    PointsG=zeros(lines+1, 3);
    PosR=zeros(lines+1, 2);
    PosG=zeros(lines+1, 2);
    PosB=zeros(lines+1, 2);
    
    %For each line, see where in the IPF region the point falls into
    for i=1:lines

        x=Rad(i)*cos(Th(i))*cos(pi/4);
        y=Rad(i)*sin(Th(i));
        z=sqrt(Rad(i)^2-x^2-y^2);
        v1=[x y z];
        Ry=v1(2);
        Rx=sqrt(v1(1)^2+v1(3)^2);

        if  Ry>Rx*m+P3(2)-m*P3(1) && Ry>Rx*p %Blue region
            PointsB(B,:)=[Rx, Ry, 0];
            PosB(B,:)   =[IMx(i), IMy(i)];
            B=B+1;
        end
        if Ry<Rx*m+P3(2)-m*P3(1) && Ry>Rx*n+(P6(2)-n*P6(1)) %Red REgion
            PointsR(R,:)=[Rx, Ry, 0];
            PosR(R,:)   =[IMx(i), IMy(i)];
            R=R+1;
        end
        if Ry<=Rx*n+(P6(2)-n*P6(1)) && Ry<=Rx*p %Green REgion
            PointsG(G,:)=[Rx, Ry, 0];
            PosG(G,:)   =[IMx(i), IMy(i)];
            G=G+1;
        end
    end

    %Delete extra rows in the matrix
    PointsG(G:lines+1,:)=[];
    PointsR(R:lines+1,:)=[];
    PointsB(B:lines+1,:)=[];
    PosG(G:lines+1,:)=[];
    PosR(R:lines+1,:)=[];
    PosB(B:lines+1,:)=[];

    %For each section of IPF convert it to colorized pixels, and combine all
    %the sections of the IPF
    [RedB, GreenB, BlueB]=colorPointBlue(PointsB(:,1), PointsB(:,2));
    [RedR, GreenR, BlueR]=colorPointRed(PointsR(:,1), PointsR(:,2));
    [RedG, GreenG, BlueG]=colorPointGreen(PointsG(:,1), PointsG(:,2));
    Red=[RedR; RedG; RedB];
    Blue=[BlueR; BlueG; BlueB];
    Green=[GreenR; GreenG; GreenB];
    Points=[PosR; PosG; PosB];
    posX=Points(:,1);
    posY=Points(:,2);