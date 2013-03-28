function newpts=transA(pts,corners,plotYN)

%this function takes in a series of x, y and z information (pts) and a set
%of corner points determined previously and outputs a new set of points
%that have been appropriately scaled to a 30 by 20um rectangle.

%works for pt boundaries from kevin's code for afrin's data

digits(5);
pts(pts(:,2)~=1,:)=[]; % takes care of kevin's duplicate data points
xlength=length(pts);
newpts=zeros(xlength,3);
for i=1:xlength
        slice=pts(i,1); %goes through each point
        corner = corners(slice,:);
        x1=corner(2); y1=corner(1);
        x2=corner(4); y2=corner(3);
        x3=corner(6); y3=corner(5); 
        x4=corner(8); y4=corner(7);
        
        cornermatrix = [1 x1 y1 (x1*y1); 1 x2 y2 (x2*y2); 1 x3 y3 (x3*y3); 1 x4 y4 (x4*y4)]; %transformation matrix
        
        matrixa =(cornermatrix)\[0; 18; 18; 0]; %matrix for new x values
        matrixb = (cornermatrix)\[0; 0; 19; 19]; %matrix for new y values
        
        oldU=pts(i,3); 
        oldV=pts(i,4);
        
        newX= [ 1, oldU, oldV, (oldU*oldV) ]* matrixa; %transformation
        newY= [ 1, oldU, oldV, (oldU*oldV) ]* matrixb;
        
        
        newpts(i,:)=[newX, newY, pts(i,1)/10]; %new point structure 
        
end

if plotYN == (1 || 'Y' || 'y')
    plot3(pts(:,1),pts(:,2),pts(:,3));
    hold on
end

end

