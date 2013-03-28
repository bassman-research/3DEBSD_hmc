function [num,str] = memavailable
%MEMAVAILABLE Returns the amount of memory available 
%   [NUM,STR] = MEMAVAILABLE returns the numerical number of bytes in NUM, 
%   and a string representation in STR. 

% Get the results of DUMPMEMMEX 
smem=evalc('feature dumpmem'); 
 
% Extract tokens 
m = regexp(smem,'(?<bytes>\d*)\sbytes[^\(]*\((?<mb>[^\)]*)\).*$','names');  
num = str2num(m.bytes); 
str = m.mb;