function [TP, FN, FP] = BenchmarkPara(detectPeak, truePeak, acceptInt)
% Benchmark the method sensitivity and positive predictivity
% for the different pressure signals with acceptance intervals

% TP - the number of true positives
% FN - the number of false negatives
% FP - the number of false positives
% truePeak - the¡°true¡± peaks
% detectPeak - the detected peaks
% acceptInt - acceptance intervals

TP = 0;
for i = 1:length(truePeak)
    % find true positives
    findPeak=find(detectPeak>=truePeak(i)-acceptInt...
                &detectPeak<=truePeak(i)+acceptInt, 1);
    if ~isempty(findPeak)
        TP = TP+1;
    end

end

% calculate false negatives
FN = length(truePeak)-TP;

% calculate false positives
FP = length(detectPeak)-TP;

