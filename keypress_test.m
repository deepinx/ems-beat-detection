%% ≤‚ ‘windowkeypressfcnœÏ”¶∫Ø ˝
function keypress_test
clc
close all
clear all
%%
fig = figure;
plot(1:10)
set(fig,'windowkeypressfcn',@keypressfcn);
set(fig,'windowkeyreleasefcn',@keyreleasefcn);
    function keypressfcn(h,evt)
        fprintf('************press \n');
        evt
        fprintf('************ \n');
    end
    function keyreleasefcn(h,evt)
        fprintf('************release \n');
        evt
        fprintf('************ \n');
    end

end