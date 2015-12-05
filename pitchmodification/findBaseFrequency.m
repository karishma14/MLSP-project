function [bestFit, fit] = findBaseFrequency(test, baseFLow, baseFHigh)
%% find the spectrum by sliding window...
maxFit = zeros(size(test,2),1);
minErr = ones(size(test,2),1)*100000;
bestFit = zeros(size(test,2),1);
bestErr = zeros(size(test,2),1);
fit = zeros(100, size(test,2));
err=0;
for i=1:size(test,2)
    for baseF=baseFLow:baseFHigh
        kernel_spectrum = MakeKernelSpectrum(baseF, test(:,1));
        %err = sum(bsxfun(@power, bsxfun(@minus, test(:,i), slidingwindow), 2));
        signalAtBaseF = bsxfun(@power, bsxfun(@times, test(:,i), kernel_spectrum), 2);

        if (signalAtBaseF(baseF)>1)
            fit(baseF, i) = sum(signalAtBaseF);
%             err = sum(bsxfun(@power, bsxfun(@minus, test(:,i), signalAtBaseF), 2));
%             if err < minErr(i)
%                 minErr(i) = err;
%                 bestErr(i) = baseF;
%             end
        else
            fit(baseF, i) = 0;
        end
    end
    [pks,locs] = findpeaks(bsxfun(@times, bsxfun(@gt, fit(:,i), 100), fit(:,i)));
    if size(locs,1) > 0
        bestFit(i) = locs(1);
    else
        [pks,locs] = findpeaks(bsxfun(@times, bsxfun(@gt, fit(:,i), 20), fit(:,i)));
        if (size(locs,1) > 0)
            bestFit(i) = locs(1);
        end
    end
end

plot(bestFit,'g.');