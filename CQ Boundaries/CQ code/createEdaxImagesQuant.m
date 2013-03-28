%Make and save images of the boundary quantizations
%   From start to stop using numCol colors

function createEdaxImagesQuant(start, stop, numCol)

for q=start:stop

    %Step 1: Import the text file
    path    =['ipfH', int2str(q), '.txt'];
    Data=importfile(path);
    clear path
    size(Data)
 
    
    %Step 2 build image from txt files
    imageipfEDAXQuant(Data, numCol);
    saveas(gcf, ['ipfPQUANT', int2str(q), '.jpg']); 
    close(gcf);

    clear Data
end