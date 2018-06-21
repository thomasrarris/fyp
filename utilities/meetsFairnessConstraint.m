function [ output ] = meetsFairnessConstraint( gamma, T )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

output = true;

for g = gamma
    if g > 0
        if g < 1/T
            output = false;
        end
    end
end
end

