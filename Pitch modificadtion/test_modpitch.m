% singing - user singing audio with sampling rate Fs
% pitch_v - base frequency (yes output of the findbasefrequency function)
% of singing
% pitch_e - base frequency of extracted vocal
% Fmin - SHOULD EQUAL TO Fs/stft_window_size <- 512 is the window size used in stft

Fs = 16000; % Change accordingly if changed stft/readAudio function
stft_window_size = 512;
[singing_corrected] = run_pitch_correction(singing, pitch_v, pitch_e, Fs, Fs/stft_window_size, 80, 1/Fs*stft_window_size*2);
