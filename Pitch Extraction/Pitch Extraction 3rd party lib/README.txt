-------------------------------------- 
  Class name : Signal 
---------------------------------- 
handles basic Signal operations and transforms. 
* wave loading 
* STFT with any window and overlap ratio from 0 to 1 
* MDCT and its inverse 
* constant Q transform 
* splitting into frames 
* onset detection 
* pitch detection 
  
Main properties that are read/write 
* s : signal 
* windowLength (ms) 
* nfft (samples) 
* overlapRatio (>=0 and <1) 
* S : stft data 
  
Main properties that are read only : 
* sLength : signal length 
* nChans : number of channels 
* nfftUtil : number of bins in the positive frequency domain 
* framesPositions, nFrames : positions and number of frames 
* sWin, sWeights : windowed data 
  
example that produced the description figure :

% Create a Signal object from a wav file 
s = Signal('linktomyfile.wav');

%set window length to 50ms 
s.windowLength = 50;

%set window overlap to 75% 
s.overlapRatio = 0.75;

%compute STFT 
s.STFT;

%display log-spectrogram 
figure(1) 
clf 
subplot 311 
imagesc(10*log10(abs(s.S(1:s.nfftUtil,:,1)).^2)); 
xlabel('frame') 
ylabel('frequency bin') 
axis xy 
title('spectrogram')

%compute f0 between 200 and 500Hz 
pitchs = s.mainPitch(200,500);

%display it 
subplot 312 
plot(pitchs) 
xlabel('frame') 
ylabel('f0 (Hz)') 
grid on 
title('f0 detection')

%Compute onsets that both appear and low and high frequencies 
onsets = s.getOnsets(0,500).*s.getOnsets(6000,15000);

%display them 
subplot 313 
plot(onsets) 
xlabel('frame') 
ylabel('onset presence') 
grid on 
title('onset detection') 
 

---------------------------- 
Note that : 
* all properties are automatically set relevantly in case of modifications. for example, when nfft is set, windowLength is changed accordingly 
* the pitch detection algorithm is designed to work with a considerable amount of background superimposed to the lead signal. It should hence give reasonable results for popular music. Note that the lead signal ought to be more or less harmonic.