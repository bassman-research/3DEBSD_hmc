%Make and save images of the ipf colormappings
%   From start to stop

function createEdaxImages(start, stop)

for q=start:stop

    %Step 1: Import the text file
    path    =['ipfH', int2str(q), '.txt'];
    Data=importfile(path);
   
    clear path
    
    %Step 2 build image from txt files
    imageipfEDAX(Data);
    saveas(gcf, ['ipfP', int2str(q), '.jpg']); 
    close(gcf);

    clear Data
end