%Create an image using the EDAX colormapping using Data
% that is formated in IPF form

function IMAGEipfEDAX(Data)

lines=length(Data);

%Create room in memmory for RGB matrices
r(250,300)=0;
g(250,300)=0;
b(250,300)=0;

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

figure,
image(Imatrix)
