%% AllImageBoundaries
%Wrapper for choosing a boundary within a quantization colormapping
% for N EdaxColormappings using ipfHn.txt files where n is a number
% shows all boundaries on one plot
% selects all image boundaries for export

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataSet = 'nickel_diecompressed';
sliceRange = [1 67];
trialColor = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc

%define some variables
start = sliceRange(1); stop = sliceRange(end);

addpath('CQ code');

%path to write to
writefolder = ['Raw Pts\' dataSet];
writename = ['MBall_colors_',num2str(trialColor)];
writePath = [writefolder '\' writename '.txt'];
fid = fopen(writePath, 'wt'); % Open for writing

%For each text file, create the edax colormapping matrix and save the image
%to another file
for q=start:stop
%    [bytesAvailable, MBavailable]=memavailable; %hahaha better than feature dumpmem
 %   MBavailable
    %feature dumpmem;
    sprintf('Processing Slice %d', q)

    dataName = ['ipf',int2str(q),'.txt'];
    dataPath=['..\Data\IPF Data\',dataSet,'\', dataName];
    Data=importfile(dataPath);
        
%Step 3 Find boundary Pts
    %Input: A matrix of the imagedata
    [cent, cords]=imBound_all(Data, trialColor);%quantization);
    pause(1)

    %imbound returned a pattern consisting of n number of closed boundaries
    %concatenate all these boundaries together
    clear Data; clear cent; 
    concatCords = [];
    for boundary = 1:length(cords)
        cords{1,boundary};
        concatCords=[concatCords;cords{1,boundary}(:,1:2)];
    end
      
    
    %define z values
    zcol = q*ones(size(concatCords,1),1);
    %find dulplicates
    [newmat,index] = unique(concatCords,'rows','first');
    repeatedIndex = setdiff(1:size(concatCords,1),index);
    repeatCol = ones(size(concatCords,1),1);
    repeatCol(repeatedIndex) = 2;
    sliceData = [zcol repeatCol concatCords];
    %write data to file
    fprintf(fid,'%.5f\t%.5f\t%.5f\t%.5f\n',sliceData');
    
    clear cords; clear concatCords; clear sliceData;
    
end

fclose(fid);