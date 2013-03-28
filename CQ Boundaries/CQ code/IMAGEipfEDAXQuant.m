%Create images using the EDAX ipf colormapping
%   A colorquantization is applied to the image using
%   NumCol

function [C]= IMAGEipfEDAXQuant(Data, NumCol)

lines=length(Data);

%Create room in memmory for RGB matrices
r(200,200)=0;
g(200,200)=0;
b(200,200)=0;

R=Data(:,1);
Th=Data(:,2);
[Red, Green, Blue, posY, posX]=EDAX(R, Th, Data(:,4), Data(:,5));

for i=1:lines
   x=posX(i);
   y=posY(i);
   r(y,x)=Red(i);
   g(y,x)=Green(i);
   b(y,x)=Blue(i);

   
end

Imatrix=cat(3, r, g, b);
figure, image(Imatrix)
[X_no_dither, map]= rgb2ind(Imatrix,NumCol,'nodither');
C = ind2rgb(X_no_dither, map);