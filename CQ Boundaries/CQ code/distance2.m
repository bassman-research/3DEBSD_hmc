function D=distance2(p1, p2)
%Version 2 (Final Version)

%P1 and P2 correspond to Nx2 matrices corresponding to X Y positions
%Distance2 returns a Nx1 vector of the corresponding distances between the
%two points

D=sqrt((p1(:,1)-p2(:,1)).^2+(p1(:,2)-p2(:,2)).^2);