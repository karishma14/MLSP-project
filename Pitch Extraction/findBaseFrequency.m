function [bestFit, fit, onsets] = findBaseFrequency(test, baseFLow, baseFHigh, ifFindOnsets)
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
        occupyRate = sum(test(find(kernel_spectrum>0.5), i) > 1)/sum(kernel_spectrum>0.9);

        if (signalAtBaseF(baseF)>0.5)
            if (occupyRate > 0.15)
                fit(baseF, i) = sum(signalAtBaseF);
            else
                fit(baseF, i) = 0;
            end
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
        if size(locs,1)>1
            [~,ind] = sort(pks,'descend');
            bestFit(i) = locs(ind(1));
        else
            bestFit(i) = locs(1);
        end
    else
        [pks,locs] = findpeaks(bsxfun(@times, bsxfun(@gt, fit(:,i), 20), fit(:,i)));
        if (size(locs,1) > 0)
            bestFit(i) = locs(1);
        end
    end
end

% Optimize bestFit by smoothing
for i=2:size(test,2)-1
    if abs(bestFit(i-1) - bestFit(i+1)) < 3
        bestFit(i) = (bestFit(i-1) + bestFit(i+1))/2;
    end
end

if (ifFindOnsets)
    % Find slop in Base Frequency sequence
    filter = [1 -1];
    slops = conv(bestFit, filter);
    slops = slops(1:end-1);
    onsets = slops > 3;
end

% plot(bestFit,'g.');