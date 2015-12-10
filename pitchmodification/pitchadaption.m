%% Pitch Modification
clear; clc; close all;
% load audio
[audio, fs] = audioread('singing_m_3.wav');
audio = (audio(:,1) + audio(:,2))/2;
pitchCoeffs = [1:0.005:2];
audio2 = modifyPitch(audio, pitchCoeffs);
audiowrite('result.wav', audio2, fs);
%% Pitch Comparison

[audio1] = readAudios('singing_f_3.wav');
[audio2] = readAudios('mine4.m4a');

pitchCoeffs = vocal_comparison(audio1, audio2)';

%% New Pitch Modification
[aud2, fs] = audioread('mine4.m4a');
pitchCoeffs = pitchCoeffs + 0.1;
newPitchCoeffs = downsampleCoefficients(pitchCoeffs, 10);
modAud2 = modifyPitch(aud2, newPitchCoeffs);
audiowrite('result.wav', modAud2, fs);