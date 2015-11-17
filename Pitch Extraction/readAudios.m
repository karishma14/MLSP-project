function [smag] = readAudios(filename)
[s,fs] = audioread(filename); 
s = resample(s,16000,fs);
sft = {};
for i=1:size(s,2)
    sft{i} = stft(s(:,i)',2048,256,0,hann(2048));
    sphase{i} = sft{i}./abs(sft{i});
    smag{i} = abs(sft{i});
end
