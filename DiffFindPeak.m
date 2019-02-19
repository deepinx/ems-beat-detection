% 用差分的方法搜索压力波形的极值点

fs=200;
data=F(min(10000,length(F)):end);
nLen=length(data);

hd=lowpass20Hz;
y=filter(hd,data);
diff_y=y(2:end)-y(1:end-1); %作差分

pos=find(abs(diff_y)<0.1);  %寻找梯度小于0.1的点，即极值点

figure
plot(y)
hold on
plot(pos,y(pos),'ro')