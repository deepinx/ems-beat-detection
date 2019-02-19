% zero phase shift bandpass filter

function output = BandPassFilter(x, fl, fh)

if isempty(x)
    return;
end

data_num = length(x);
y = zeros(1,data_num);
dx = zeros(1,data_num);
output = zeros(1,data_num);

for i=1:data_num
	dx(i)=x(i);
end

wl = 2*fl*3.14159265*0.003125;   
wh = 2*fh*3.14159265*0.003125;    
b = wh-wl;
w0 = wh*wl;
a0 = b/(1+b+w0);
a1 = 2*(1-w0)/(1+b+w0);
a2 = 2*a0-1;
y(data_num) = a0*dx(data_num);
y(data_num-1) = a0*dx(data_num-1)+a1*y(data_num);

for i=data_num-2:-1:1
    y(i) = a0*(dx(i)-dx(i+2))+a1*y(i+1)+a2*y(i+2);
end

dx(1) = a0*y(1);
dx(2) = a0*y(2)+a1*dx(1);

for i=3:data_num
    dx(i) = a0*(y(i)-y(i-2))+a1*dx(i-1)+a2*dx(i-2);
end

for i=1:data_num
    output(i) = dx(i);
end

