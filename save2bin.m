clear
load('./AbpSignal/POX.mat');
fid = fopen('spo2_demo.bin', 'w');
fwrite(fid, pox1, 'int');
fclose(fid);