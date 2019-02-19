% the main program

% clc
clear

% start timing
tic

% file name
% matName = './AbpSignal/248m.mat';
% infoName = './AbpSignal/248m.info';
acceptInt = 6;
MaxIterLoop = 10;
MeanShiftStep = 20;

% read data from file
% fprintf('Reading Data From %s...\n',matName);
% [val, Fs] = ReadDataATM(matName,infoName);
% data = val(400000:450000);
fprintf('\n\nReading Data From ABP.mat...(abp1)\n');
load ./AbpSignal/ABP
data = abp1;
Fs = 125;
% Fs = 1/interval;  % Sampling Frequency

% zero-phase lowpass filter
b=[1 2 1]*0.052;
a=[1 -1.37 0.58];
dataf=filtfilt(b,a,data);

% calculate heart rate using PSD
HeartRate = PsdCalcHR(data, Fs);
fprintf('Estimating Heat Rate Using PSD...(%.0f/min)\n', HeartRate);

% calculate SSF
ssf = SSF(dataf, length(dataf), HeartRate, Fs);
% plot(ssf); hold on

% mean shift detect peaks
h=0.18/(HeartRate/60)*Fs;
peak = MeanShiftDetectPeak(ssf, h, MeanShiftStep);
% plot(peak,ssf(peak),'ro')

% IBI Classification Logic
mIBI = 60/(HeartRate)*Fs;
lastPeak = zeros(1,1);
IBI = peak(2:end)-peak(1:end-1);
overPeak = find(IBI(1:end-1)<mIBI/1.75|IBI(2:end)<mIBI/1.75)+1;
% stem(peak(overPeak), data(peak(overPeak)), 'r+')
peak(overPeak) = [];   % delete over peaks in the array
for iterLoop = 1:MaxIterLoop  % 最大迭代次数
    IBI = peak(2:end)-peak(1:end-1);
    missPeak = find(IBI(1:end-1)>mIBI/0.75);
    % stem(peak(missPeak), ssf(peak(missPeak)), 'r*')
    % missPeak = missPeak+(0:length(missPeak)-1);
    for i=1:length(missPeak)
        pos = missPeak(i);
        w = round(60/(HeartRate*1.75)*Fs);
        missData = data(peak(pos)+w:peak(pos+1)-w);
        findPeak = find(missData==max(missData),1);
        if (findPeak~=1)&&(findPeak~=length(missData))
            peak = [peak(1:pos) findPeak+peak(pos)+w peak(pos+1:end)]; 
            missPeak = missPeak+[zeros(1,i),ones(1,length(missPeak)-i)];
        end
        % plot(missData); hold on; 
        % plot(findPeak-w,missData(findPeak-w),'ro');
    end
    % conditions to end the iteration
    if isempty(missPeak)
        break;
    elseif isequal(missPeak,lastPeak)
        break;
    else
        lastPeak = missPeak;
    end
end

% final calibrate the peaks
fprintf('Calibrating Peak From Nearest Maxima...\n');
peak = CalibrePeak(data, peak, 6);

% stop timing and show elapsed time
toc

% Benchmard Parameters of the method
% sensitivity and positive predictivity
% dDT1 = CalibrePeak(data, dDT1, 6);
[TP1, FN1, FP1] = BenchmarkPara(peak, dDT1, acceptInt);
Se1 = TP1/(TP1+FN1)*100;
Po1 = TP1/(TP1+FP1)*100;
[TP2, FN2, FP2] = BenchmarkPara(d1, dDT1, acceptInt);
Se2 = TP2/(TP2+FN2)*100;
Po2 = TP2/(TP2+FP2)*100;

% plot the detection result
t = (1:length(data))/Fs;
h  = plot(t, data, peak/Fs, data(peak), 'ro', ...
    d1./Fs, data(d1), 'b+', ...
    dDT1./Fs, data(dDT1), 'kx'); 
set(h, 'Markersize', 10);
legend('Raw Signal', 'SMSS Detector', 'Detector [17]', 'Expert-1 (DT)');
xlabel('Time, s');
ylabel('Signal & Detection');


% start timing
tic
        
% read data from file
% fprintf('Reading Data From %s...\n',matName);
% [val, Fs] = ReadDataATM(matName,infoName);
% data = val(400000:450000);
fprintf('Reading Data From ABP.mat...(abp2)\n');
load ./AbpSignal/ABP
data = abp2;
Fs = 125;
% Fs = 1/interval;  % Sampling Frequency

% zero-phase lowpass filter
b=[1 2 1]*0.052;
a=[1 -1.37 0.58];
dataf=filtfilt(b,a,data);

% calculate heart rate using PSD
HeartRate = PsdCalcHR(data, Fs);
fprintf('Estimating Heat Rate Using PSD...(%.0f/min)\n', HeartRate);

% calculate SSF
ssf = SSF(dataf, length(dataf), HeartRate, Fs);
% plot(ssf); hold on

% mean shift detect peaks
h=0.18/(HeartRate/60)*Fs;
peak = MeanShiftDetectPeak(ssf, h, MeanShiftStep);
% plot(peak,ssf(peak),'ro')

% IBI Classification Logic
mIBI = 60/(HeartRate)*Fs;
lastPeak = zeros(1,1);
IBI = peak(2:end)-peak(1:end-1);
overPeak = find(IBI(1:end-1)<mIBI/1.75|IBI(2:end)<mIBI/1.75)+1;
% stem(peak(overPeak), data(peak(overPeak)), 'r+')
peak(overPeak) = [];   % delete over peaks in the array
for iterLoop = 1:MaxIterLoop  % 最大迭代次数
    IBI = peak(2:end)-peak(1:end-1);
    missPeak = find(IBI(1:end-1)>mIBI/0.75);
    % stem(peak(missPeak), ssf(peak(missPeak)), 'r*')
    % missPeak = missPeak+(0:length(missPeak)-1);
    for i=1:length(missPeak)
        pos = missPeak(i);
        w = round(60/(HeartRate*1.75)*Fs);
        missData = data(peak(pos)+w:peak(pos+1)-w);
        findPeak = find(missData==max(missData),1);
        if (findPeak~=1)&&(findPeak~=length(missData))
            peak = [peak(1:pos) findPeak+peak(pos)+w peak(pos+1:end)]; 
            missPeak = missPeak+[zeros(1,i),ones(1,length(missPeak)-i)];
        end
        % plot(missData); hold on; 
        % plot(findPeak-w,missData(findPeak-w),'ro');
    end
    % conditions to end the iteration
    if isempty(missPeak)
        break;
    elseif isequal(missPeak,lastPeak)
        break;
    else
        lastPeak = missPeak;
    end
end

% final calibrate the peaks
fprintf('Calibrating Peak From Nearest Maxima...\n');
peak = CalibrePeak(data, peak, 6);

% stop timing and show elapsed time
toc

% benchmark parameters
% dDT2 = CalibrePeak(data, dDT2, 6);
[TP, FN, FP] = BenchmarkPara(d2, dDT2, acceptInt);
Se2 = (Se2+TP/(TP+FN)*100)/2;
Po2 = (Po2+TP/(TP+FP)*100)/2;
FN2 = FN+FN2;
FP2 = FP+FP2;
fprintf('Prev Detector: Se=%2.2f%%, +P=%2.2f%%\n', Se2, Po2);
fprintf('               FN=%d, FP=%d\n', FN2, FP2);
[TP, FN, FP] = BenchmarkPara(peak, dDT2, acceptInt);
Se1 = (Se1+TP/(TP+FN)*100)/2;
Po1 = (Po1+TP/(TP+FP)*100)/2;
FN1 = FN+FN1;
FP1 = FP+FP1;
fprintf('SMSS Detector: Se=%2.2f%%, +P=%2.2f%%\n', Se1, Po1);
fprintf('               FN=%d, FP=%d\n', FN1, FP1);

% plot the detection result
t = (1:length(data))/Fs;
h  = plot(t, data, peak/Fs, data(peak), 'ro', ...
    d2./Fs, data(d2), 'b+', ...
    dDT2./Fs, data(dDT2), 'kx'); 
set(h, 'Markersize', 10);
legend('Raw Signal', 'SMSS Detector', 'Detector [17]', 'Expert-1 (DT)');
xlabel('Time, s');
ylabel('Signal & Detection');