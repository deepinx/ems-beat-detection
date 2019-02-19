% calibrate the peaks

function peakCalibre = CalibrePeak(data, peak, range)

peakCalibre = zeros(1,length(peak));
for i=1:length(peak)
    lPos = max(peak(i)-range,1);
    rPos = min(peak(i)+range,length(data));
    dataf = data(lPos:rPos);
    realPos = find(dataf==max(dataf),1);
    peakCalibre(i) = lPos+realPos-1;
end