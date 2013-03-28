%% plots multiple surfaces for nickel data
clf

folder = 'Surfaces\nickel_diecompressed';
start = 0; stop  = 3.2;

%% messy surfaces
% name = 'surface_messy';
% numbers = [1];
% colors = [.5 1 1];
% plot_surfaces(folder,name,numbers,start,stop,colors)

%% scar surfaces
name = 'surface_scar';
numbers = [1];
colors = [1 0 0; 0 1 0; 0 0 1];
plot_surfaces(folder,name,numbers,start,stop,colors)

%% uk surfaces
name = 'surface_uk';
numbers = [1:5];
colors = [1 1 0; 1 0 1; 0 1 1; 1 .5 1; 1 1 .5];
plot_surfaces(folder,name,numbers,start,stop,colors)

%% plot parameters

legend('messy1',...
       'scar1','scar2','scar3',...
       'uk1','uk2','uk3','uk4','uk5')
   
 view(0,90)
 axis([0 12 0 20 0 3.2])
 grid on
 grid minor
