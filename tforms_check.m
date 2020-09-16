%%
clc;clear;close all;

load('tforms_normal.mat');
load('tforms_odd.mat');
load('tforms_even.mat');
%%

for i= 1:numel(tforms_odd)
    string(2*i-1)
    tforms_normal(2*i-1).T
    tforms_odd(i).T
end

%%
string(1)
tforms_normal(1).T
tforms_even(1).T
for i= 1:numel(tforms_even)-1
    string(2*i)
    tforms_normal(2*i).T
    tforms_even(i+1).T
end