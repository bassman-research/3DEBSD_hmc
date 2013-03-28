clc; close all; hold off;

dataSet = 'nickel_diecompressed';
slices = [1:67];

%% load corner points
folder = '..\Data';
path = strcat(folder,'\Corner Points\',dataSet,'.mat');
corner = importdata(path);
%corner = corners_nickel;
corner = 10*corner;
addpath('CQ code')

numSlices = length(slices);
for sliceIndex = 1:numSlices
slice = slices(sliceIndex);
%% Path to read from
path = strcat(folder,'\IPF Data\',dataSet,'\ipf', int2str(slice), '.txt');

%% Import that data from path and corner points
Data=importdata(path);

%% plot data and check that its OK
clf
clear X
X=IMAGEipfEDAXQuant(Data, 2);
close(gcf)

rgb_columns = reshape(X, [], 3);

%We want the unique colors found in rgb_columns 
[unique_colors, m, n] = unique(rgb_columns, 'rows');
color_counts = accumarray(n, 1);

%Creates the 3-d vector for boundary lines of each plot
f=0;
cen=1;
clear cords;

% -------------------------do stuff---------------------------------

%plot colorful thing
i=2;

%do magic
bw = n == i;
bw = reshape(bw, size(X, 1), size(X, 2));
L = bwlabel(bw);
s = regionprops(L, 'Area', 'Centroid');
%own code based on principles shown in Steve's Blog
%Takes the labels of a given slip plane and shows only those of a certain
%threshold size
Thresh=500;
L = bwlabel(bw);
NewL=zeros(size(L));

for k=1:numel(s)
    if (s(k).Area) >Thresh
        s(k).Centroid;
        cent(cen,:)=s(k).Centroid;
        cen=cen+1;
        NewL=NewL+(L==k);
    end
end
%Plots boundaries of the slices not including holes in a slice
%Can get position of boundary pixes by use of [B,L,N,A]=boundaries(bw)
%See matlab for more info
b = bwboundaries(NewL, 'noholes');
if size(b)>0

    %Plot each chunk in slice individually
    %Controls max # of plots in window, Set this indvidually on what
    %one expects

    subplot(1,1,1),subimage(X)
    Vaxis = axis;
    
    for j = 1:numel(b)
        f=f+1; %Counter for object # in subimage
        %subplot(numSlices,numTrials,trial), subimage(NewL);
        %subplot(8,5,f), subimage(NewL);
        hold on

        %Plot the boundary
        subplot(1,1,1),plot(b{j}(:,2), b{j}(:,1), 'b', 'Linewidth', 1)
        hold on           
        axis(Vaxis);
        title(strcat('slice ',num2str(slice)))

        %store cordinate information for image f
        %size(cords{1, f}(:,2))
        %size(b{j}(:,2))
        cords{1, f}(:,2)=b{j}(:,2);
        cords{1, f}(:,1)=b{j}(:,1);
    end
    set(gca,'YDir','reverse');
end

%need to delete cell array contents
for j=1:numel(b)
    b(1)=[];
end
clear b;

%% plot border from corner points
x1=corner(slice,1); y1=corner(slice,2);
x2=corner(slice,3); y2=corner(slice,4);
x3=corner(slice,5); y3=corner(slice,6);
x4=corner(slice,7); y4=corner(slice,8);

line([x1 x2; x2 x3; x3 x4; x4 x1],...
     [y1 y2; y2 y3; y3 y4; y4 y1],'linestyle',':','color','r')

pause(.5)
end