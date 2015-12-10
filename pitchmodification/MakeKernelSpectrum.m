function [kernel_spectrum] = MakeKernelSpectrum(baseF, signal)
kernel_spectrum = zeros(size(signal));

% little kernel at each peak frequency
sKernel = [0.1 0.3 0.8 1 0.8 0.3 0.1];

for i=1:(size(signal,1)/baseF - 1)
    centerF = baseF*i;
    kernel_spectrum(centerF-3:centerF+3) = sKernel;
end


