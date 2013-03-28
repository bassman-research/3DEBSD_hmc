function [NDat]=importMatFile(fileToRead)
%IMPORTFILE(FILETOREAD1)
%  Imports data from the specified file
%  FILETOREAD1:  file to read

rawData = importdata(fileToRead);

[unused,name] = fileparts(fileToRead);
newData.(genvarname(name)) = rawData;

NDat=newData.(name);