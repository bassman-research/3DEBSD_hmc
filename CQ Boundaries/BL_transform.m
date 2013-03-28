%% Bi-Linear Transformation
% transforms data
% plots, animates, and trucates it as desired

dataSet = 'nickel_diecompressed';
dataName = 'MBall_colors_2';



clc; clf; hold off;
%% import corners
folder = '..\Data\Corner Points';
cornerPath = [folder,'\',dataSet,'.mat'];
corners = importdata(cornerPath);

%% import data
dataPath = ['Raw Pts\',dataSet,'\',dataName,'.txt'];
pts = importdata(dataPath);

%% bilinear transformation

newpts = transA(pts,10*corners,'N');

%% plot

plot3(newpts(:,1),newpts(:,2),newpts(:,3),'.','markersize',2)

axis([0 20 0 20])
set(gca,'fontsize',20)
xlabel('RD')
ylabel('TD')
zlabel('ND')
%view(0,-90)
view(35,-52)
print(gcf,['nickel_diecompressed_boundary_3D' '.tiff'],'-dtiff','-r300')


%% movie of slices
%{
slices = 1:67;
hold off
for slice = slices
    slicePts = newpts(newpts(:,3)==slice/10,:);
    plot(slicePts(:,1),slicePts(:,2),'.','markersize',5)
    title(['slice' int2str(slice)])
    axis([0 20 0 20])
    xlabel('RD')
    ylabel('TD')
    zlabel('ND')
    pause(1)
end
%}
%% truncate and write data
%{
slicerange = [1 67];

writePath = ['Transformed Pts\' dataSet '\' dataName '.txt'];
writePts = newpts(( (newpts(:,3)>=slicerange(1)/10) &...
                    (newpts(:,3)<=slicerange(end)/10) ),:);
dlmwrite(writePath,writePts,'delimiter','\t','precision','%.5f');
%}

