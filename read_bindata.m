fid=fopen('spo2_demo.bin');
m5=fread(fid,inf,'int');
fclose(fid);
plot(m5)