%Generates centroids of each region as well as cordinates for the boundary
%of each major region. The size (number of pixels) that defines by regions
%is determined by Thresh (variable in the program).

function [cent, cords]= imBound_all(Data, trialColors)

%check to see if image is appropiate


%% LOOP TO COUNT MAX NUMBER OF PATTERNS. VERY INEFFICIENT CODE
%{
maxColors = max(trialColors);

%build image from txt files
clear X
X = IMAGEipfEDAXQuant(Data, maxColors);%quantization(1));
close(gcf)

%Note code here taken from Steve's Blog
%Make X a 2d matrix for future manipulation hencforth referred to as
%rgb_columns. 
rgb_columns = reshape(X, [], 3);

%We want the unique colors found in rgb_columns 
[unique_colors, m, n] = unique(rgb_columns, 'rows');
color_counts = accumarray(n, 1);

%Creates the 3-d vector for boundary lines of each plot
cen=1;

%Here we want to find the slip planes corresponding to the various 
%unique colors found by unique(). The indexes were stored in m, so
%we check each index for valid slip planes
numPatterns = numel(unique_colors)/3;
patterns = [];

for i=1:numPatterns
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
        patterns = [patterns i];
    end

    %need to delete cell array contents
    for j=1:numel(b)
        b(1)=[];
    end
    clear b;

end

maxPatterns = length(patterns(2:end));
%}



%% ACTUAL LOOP TO PLOT STUFF
% each row corresponds to a certain number of colors
% within each row, each column is a different pattern of microbands
numTrials = length(trialColors);

for trial = 1:numTrials
    %build image from txt files
    clear X
    X = IMAGEipfEDAXQuant(Data, trialColors(trial));
    close(gcf)

    %Note code here taken from Steve's Blog
    %Make X a 2d matrix for future manipulation hencforth referred to as
    %rgb_columns. 
    rgb_columns = reshape(X, [], 3);

    %We want the unique colors found in rgb_columns 
    [unique_colors, m, n] = unique(rgb_columns, 'rows');
    color_counts = accumarray(n, 1);

    %Human error check to see if the number of colors is correct
    %fprintf('There are %d unique colors in the image.\n', ...
    %    size(unique_colors, 1))
    unique_colors;
    m;

    %Creates the 3-d vector for boundary lines of each plot
    f=0;
    cen=1;
    clear cords;


    %% Do Stuff and Plot all Subplots

    for i=2:numel(unique_colors)/3
        %plot colorful thing

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
        if i == 2
        subplot(1,numTrials,trial),subimage(X)
        Vaxis = axis;
        hold on
        end

        b = bwboundaries(NewL, 'noholes');
        if size(b)>0
            %Plot each chunk in slice individually
            %Controls max # of plots in window, Set this indvidually on what
            %one expects
            


            for j = 1:numel(b)
                f=f+1; %Counter for object # in subimage
                %subplot(numSlices,numTrials,trial), subimage(NewL);
                %subplot(8,5,f), subimage(NewL);
                hold on

                %Plot the boundary
                subplot(1,numTrials,trial),...
                    plot(b{j}(:,2), b{j}(:,1), 'b', 'Linewidth', 1)
                hold on           
                axis(Vaxis);
                %store cordinate information for image f
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

    end %end of for every color loop

end %end of for every trial color loop

%{
    %% Now do it again for the desired data set and save it
    if auto ~= 1
        selection = input('Which Subplot do you want? [row col]: ');
    else
        selection = [1 1];
    end
        
    colors = trialColors(selection(1));
    pattern  = patternChoices(selection(1),selection(2));

    X=IMAGEipfEDAXQuant(Data, colors);
    close(gcf);

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
    i=pattern;

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

        if auto ~= 1
            subplot(1,1,1),subimage(X)
            Vaxis = axis;
        end

        for j = 1:numel(b)
            f=f+1; %Counter for object # in subimage
            %subplot(numSlices,numTrials,trial), subimage(NewL);
            %subplot(8,5,f), subimage(NewL);
            hold on

            %Plot the boundary
            
            if auto ~= 1
                subplot(1,1,1),plot(b{j}(:,2), b{j}(:,1), 'b', 'Linewidth', 1)
                hold on           
                axis(Vaxis);
            end          
            
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

    %% check
    
    if auto ~= 1
        isgood = input('Is this the droid your looking for? Y(1) N(0): ');
    else
        isgood = 1;
    end
    
    while (isgood ~= 0)&&(isgood ~= 1)
        'invalid input, try try again, but harder'
        isgood = input('Is this the droid your looking for? Y(1) N(0): ');
    end


end %end of isgood while loop


%}
end