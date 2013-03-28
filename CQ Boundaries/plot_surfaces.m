function plot_surfaces(folder,name,numbers,start,stop,colors)

for file = 1:length(numbers)
    number = num2str(numbers(file));
    path = [folder '\' name number '.txt'];
    data = load(path);
    
    if nargin == 6
        plotcolor = colors(file,:);
        seperate(data,start,stop,plotcolor);
        hold on
    else
        seperate(data,start,stop)
        hold on
    end
end

