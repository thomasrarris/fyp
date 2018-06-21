function [ output ] = meetsCacheSize(gamma, C)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

output = false;
if sum(gamma) <= C
    output = true;
end

end

