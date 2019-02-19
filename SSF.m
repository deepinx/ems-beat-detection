% //=============================================================
% //斜率和函数
% //z(i)=sigma(delta_u(k));i-w<=k<=i
% //delta_y[k]>0,delta_u(k)=delta_y[k];
% //delta_y[k]<=0,delta_u(k)=0;
% //delta_y[k]=y[k]-y[k-1];
% //w=128ms or 32 samples for the fs of 250Hz，近似等于上升时间
% //=============================================================
function ssf = SSF(y, nLen, HeartRate, fs)

fprintf('Calculating Slope Sum Function...\n');

N = nLen;
delta_y = zeros(1,N);
delta_u = zeros(1,N);
ssf = zeros(1,N);

w = round(0.18/(HeartRate/60)*fs);  %the typical duration of the upslope of the ABP pulse

delta_y(1) = 0;
for k=2:N
    delta_y(k) = y(k)-y(k-1);%diff
end
%delta_y(2:N) = y(2:N)-y(1:N-1);%diff

for k=1:N
    if delta_y(k) > 0
        delta_u(k) = delta_y(k);
    else
        delta_u(k) = 0;
    end
end

for i=1:w
    ssf(i) = 0;
end

for i=w+1:N
    ssf(i) = sum(delta_u(i-w:i));%//ssf[i]=sum(delta_u[i-w:i]);//slope sum
end
    
 