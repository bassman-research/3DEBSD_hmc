function seperate(Pts_name,start,stop,plotcolor)

attempt= Pts_name; %transformed pts

plot1= [];
for x=1:length(attempt); 
    if attempt(x,3) >= start-.01;
        if attempt(x,3) <= stop+.01;
           plot1=[plot1; attempt(x,1) attempt(x,2) attempt(x,3)];
        end
    end
end

plot1(:,3) = plot1(:,3)-.1;

if nargin == 4
    plot3(plot1(:,1), plot1(:,2),plot1(:,3), '.','markersize',5,'color',plotcolor)
else
    plot3(plot1(:,1), plot1(:,2),plot1(:,3), '.','markersize',5)
end