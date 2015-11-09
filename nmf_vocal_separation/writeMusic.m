function [] = writeMusic(syn, sphase, name)

syn_complex = syn.*sphase;
approx = stft(syn_complex,2048,256,0,hann(2048));
disp('Writing...');
audiowrite(name,approx',16000);