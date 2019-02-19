% run a t-test for comparision between SSMS method and
% Aboy's method

clear

x = [98.85 97.69 99.45 98.28 99.61 98.45 99.74 98.57];  % SSMS
y = [91.07 90.21 98.06 97.14 99.18 98.25 99.37 98.43];  % Aboy

% run t-test
% Mean of x is greater than mean of y (right-tail test)
% Assumes equal variances. 
[h,p,ci] = ttest2(x,y,[],'right','equal')