function HeatRate = PsdCalcHR(data, Fs)
% Compute the PSDs using Welch's method, which is similar to the
% MSCOHERE function


% plot(x',val');
% for i=1:length(signal),labels{i}=strcat(signal{i},' (',units{i},')'); end
% legend(labels);
% xlabel('Time (sec)');

% Fs = 1000;   
% t = 0:1/Fs:1;
% % 200Hz cosine + noise
% x = cos(2*pi*t*200) + randn(size(t));   

Nt = 512;

Fstop1 = 0.2;         % First Stopband Frequency
Fpass1 = 0.33;        % First Passband Frequency
Fpass2 = 8;           % Second Passband Frequency
Fstop2 = 10;          % Second Stopband Frequency
Astop1 = 40;          % First Stopband Attenuation (dB)
Apass  = 1;           % Passband Ripple (dB)
Astop2 = 40;          % Second Stopband Attenuation (dB)
match  = 'passband';  % Band to match exactly

% Construct an FDESIGN object and call its CHEBY2 method.
h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);
Hd = design(h, 'cheby2', 'MatchExactly', match);

% filter the signal with bandpass filter
seg_x = filter(Hd,data);

% pwelch(x,128,120,[],Fs,'onesided')
[Sxx, F] = pwelch(seg_x,hamming(Nt),Nt/2,Nt*2-1,Fs);

% plot(F,10*log(Sxx))

% calculate HR using PSD
HeatRate = F(find(Sxx==max(Sxx)))*60;

