%Wrapper for choosing a boundary within a quantization colormapping
% for N EdaxColormappings using ipfHn.txt files where n is a number
% use selectImageBoundaries(1,32,[2],1) to output the boundary/outline
% of all slices
function [pts]= selectImageBoundaries(start, stop,trialColors,auto)%, quantization)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataSet = 'nickel_diecompressed';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('CQ code');

N = stop;
pts{1}=zeros(1, 1);
pts(1)=[];
cents=zeros(N, 2);

if ((auto ~= 1)&&(auto ~= 0))
    'choose auto=1 for quick scan of all slices, else auto=0'
end

%For each text file, create the edax colormapping matrix and save the image
%to another file
for q=start:stop
%    [bytesAvailable, MBavailable]=memavailable; %hahaha better than feature dumpmem
 %   MBavailable
    %feature dumpmem;
    sprintf('Processing Slice %d', q)
    temp=pts;
    
    %delete pt array to clean up memory
    for j=1:numel(pts)
        pts(1)=[];
    end
    clear pts
    
    dataName = ['ipf',int2str(q),'.txt'];
    dataPath=['..\Data\IPF Data\',dataSet,'\', dataName];
    Data=importfile(dataPath);
    clear path

    
% %Step 2 build image from txt files\
  %  QData = IMAGEipfEDAXQuant(Data,5);%quantization(1));
   %  close(gcf);
    
%Step 3 Find boundary Pts
    %Input: A matrix of the imagedata
    [cent, cords]=imBound(Data, trialColors, auto);%quantization);
    %{
    hold on
    subplot(4,4,16)
    imshow(QData);
    hold off
    %}
    %choose image as boundary of interest
    %choice = input('Choose an Image from Figure as Correct Slice') 
    %close(gcf);
    
    %imbound returned a pattern consisting of n number of closed boundaries
    %concatenate all these boundaries together
    clear tempCords;
    tempCords{1,1}(:,1:2)=cords{1,1}(:,1:2);
    for boundary = 2:length(cords)
        tempCords{1,1}=[tempCords{1,1};cords{1,boundary}(:,1:2)];
    end
    clear cords;
    cords{1,1} = tempCords{1,1};
        
    choice = 1;
    
    temp{q}(:,2)= cords{choice}(:,2);
    temp{q}(:,1)= cords{choice}(:,1);
    
    cents(q,:)=cent(choice,:);
    clear cent
    
    %need to delete cell array contents
    for j=1:numel(cords)
        cords(1)=[];
    end
    clear cords
    
    %1st create new cell array pts
    for i=1:q
        pts{i}=temp{i};
    end
    
    %delete temporary array
    for j=1:numel(temp)
        temp(1)=[];
    end 
    clear temp
    clear QData
    clear Data
        
    %sprintf('Finished Processing Slice %d', q)
end



%Write the points information to an external file
fid = fopen('Pts.txt', 'wt'); % Open for writing

for p=1:N
    A= [p*ones((numel(pts{p})/2), 1), 1*ones((numel(pts{p})/2),1) ,pts{p}, 24*(p-1)*ones((numel(pts{p})/2), 1)];
    for i=1:(numel(A)/5)
        fprintf(fid, '%d %d %d %d %d\n', A(i,:) );
    end
   clear A;
    A= [p*ones((numel(pts{p})/2),1 ), 2*ones((numel(pts{p})/2),1), pts{p}, 24*p*ones((numel(pts{p})/2), 1)];
    for i=1:(numel(A)/5)
        fprintf(fid, '%d %d %d %d %d\n', A(i,:) );
    end
   clear A;
end
fclose(fid);

%Write the centroid information to an external file
%{
fid = fopen('Centroids.txt', 'wt'); % Open for writing
for p=1:N
    A= cents(p,:);
    for i=1:(numel(A)/2)
        fprintf(fid, '%d %d \n', A(i,:) );
    end
end
fclose(fid);
%}