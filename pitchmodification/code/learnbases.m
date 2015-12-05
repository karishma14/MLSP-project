% load singing spectrum
[s,fs] = audioread('LoveMeLikeYouDo.mp3'); 
s = (s(:,1)+s(:,2))/2; % mono
s = resample(s,16000,fs);
[sft, sftp] = stft(s',2048,256,0,hann(2048));
sphase = sft./abs(sft);
smag = abs(sft);

% learn bases
% [W, H] = nnmf(smag, 50);
[W, H, ~, ~] = nmf_kl_sparse_v(smag, 50);
approx = W*H;
approx_sft = sphase .* approx;
approx_s = stft(approx_sft, 2048, 256, 0, hann(2048));
approx_s = resample(approx_s,16000,fs);

audiowrite('rere.wav', approx_s, fs);
% 
% % load norah jones
% [s2, fs2] = audioread('norah_jones_nearnessofyou.mp3');
% s2 = (s2(:,1)+s2(:,2))/2; % mono
% s2 = resample(s2,16000,fs2*2);
% [sft2, sftp2] = stft(s2',2048,256,0,hann(2048));
% sphase2 = sft2./abs(sft2);
% smag2 = [abs(sft2) abs(sft2)];
% projection = pinv(H') * smag2(:, 1:8594)';
% 
% % resynthesize norah jones
% projection_spectrum = H' * projection;
% myphase = sphase(:,1:8594);
% projection_sft = myphase' .* projection_spectrum;
% projection_s = stft(projection_sft', 2048, 256, 0, hann(2048));
% projection_s = resample(projection_s,16000,fs*2);
% audiowrite('norah_synth.wav', projection_s, fs);
