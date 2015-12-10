function [newCoeffs] = downsampleCoefficients(oldCoeffs, n)
% downsamples coefficients by factor of n

newCoeffs = [];
for i=1:n:(length(oldCoeffs)-n)
    finish = i+n-1;
    coeffs = oldCoeffs(i:i+n-1);
    average = mean(coeffs);
    newCoeffs = [newCoeffs average];
end

end

