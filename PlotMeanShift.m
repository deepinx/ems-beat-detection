% introduction to meanshift
function PlotMeanShift(x,sigma)

% x can not be 0
%x=(x-min(x))./(max(x)-min(x))+0.1;

t=0:1:length(x)+1;

for i=1:length(x)
    f1(i,:)=x(i).*i.*exp(-(t-i).^2./(2*sigma*sigma))./sigma./sqrt(2*pi);
    f1(i,:)=f1(i,:)/(max(f1(i,:)))*x(i);
end
fx1=sum(f1)./length(f1).*100;

%figure(2000)
plot(t/125,fx1,'linewidth',2);
% plot(t,f1','linewidth',2);
