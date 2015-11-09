addpath('nmfv1_4');

smooth_filter = [0.1 0.5 1 1 1 0.5 0.1];

disp('Reading the original song...')
[smag_original sphase_original] = readAudios('music_clipped.wav'); % Original song
original = smag_original{1};
original_phase = sphase_original{1};
energy_orig = log(sum(original,1)+eps);
energy_orig = conv(energy_orig, smooth_filter);

disp('Reading the pure vocal cover...')
smag = readAudios('singing_clipped.wav'); % Singing recording
test=smag{1};
test = test(:,1:size(original,2));
energy_test = log(sum(test,1)+eps);
energy_test = conv(energy_test, smooth_filter);
energy_test = energy_test(size(smooth_filter,2):end);

pure_music = zeros(size(original));
pure_music = original(:,energy_test<10);
writeMusic(pure_music, original_phase(:,energy_test<10), 'puremusic.wav');

option.algorithm = 'sparsenmf2rule';
[A,Y,numIter,tElapsed,finalResidual] = nmf(pure_music', 30, option);

reprojM = A*inv(A'*A)*A';


%% nmf

[A,Y,numIter,tElapsed,finalResidual] = nmf(pure_music, 20, option);
music_syn = reprojM*original;
writeMusic(music_syn, sphase_original{1}, 'synmusic.wav');



% disp('Finding the base Frequencies...')
% [bestFit, fit] = findBaseFrequency(test, 20, 80);
% [bestFit_orig, fit_orig] = findBaseFrequency(original, 20, 80);

% figure;
% subplot(1,2,1);imagesc(fit);hold on;plot(bestFit,'g.');
% subplot(1,2,2);imagesc(fit_orig);hold on;plot(bestFit,'g.');