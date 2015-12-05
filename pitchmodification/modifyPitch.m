function [audioModified] = modifyPitch(audio, pitchCoefficients)

nwindows = length(pitchCoefficients);
windowSize = floor(length(audio)/nwindows);
audioModified = [];
for i=1:nwindows
    start = (i-1)*windowSize + 1;
    finish = i*windowSize;
    originalWindow = audio(start:finish, 1);
    pitchCoeff = 1/pitchCoefficients(i);
    timeScaledWindow = pvoc(originalWindow, pitchCoeff);
    [P,Q] = rat(pitchCoeff);
    pitchModifiedWindow = resample(timeScaledWindow, P, Q);
    audioModified = [audioModified; pitchModifiedWindow];
end

end

