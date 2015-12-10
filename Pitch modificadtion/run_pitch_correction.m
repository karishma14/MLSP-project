function [A_corrected] = run_pitch_correction(A, f0, f0_corrected, Fs, Fmin, Fmax, block_length)
% hObject    handle to pitch_detect_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(A)
    return
end
t = (0:length(A)-1)./Fs;
plot_on = false;

% block_length = 0.02;
step_per_block = 2;
block = step_per_block*round(block_length*Fs/step_per_block);
step = block/step_per_block;

scale_factor = zeros(size(f0));
A_corrected = zeros(size(A));              

N = length(f0);

max_acorr_shift = 0;
max_acorr_amp = 0;  

I = 1;
for n = 1:N

    % Pull out a chunk of the signal
%     Atemp = A(I:I+block-1);
%     ttemp = t(I:I+block-1);
       
    if f0(n) > 0 && ~isnan(f0(n)) && f0_corrected(n) > 0
        
        % Calculate the scale factor by which to shift the frequency
        scale_factor(n) = f0_corrected(n)/f0(n);
%         scale_factor(n) = min(max(f0_corrected(n)/f0(n), 0.8),1.2);
%         if scale_factor(n) == 0.8 || scale_factor(n) == 1.2
%             scale_factor(n) = 1;
%         end
    else
        % No frequency shift
        scale_factor(n) = 1;
        
    end
    
    I = I+step;
    
end

filter_smooth = ones(1, 10)/10;
scale_factor = medfilt1(scale_factor, 20);
scale_factor = filter(filter_smooth, 1, scale_factor);

I = 1;
for n = 1:N - step_per_block + 1
    Atemp = A(I:I+block-1);
    ttemp = t(I:I+block-1);
    
    if f0(n) > 0 && ~isnan(f0(n)) && f0_corrected(n) > 0
        % Interpolate
        tp = mean(ttemp) + (ttemp-mean(ttemp)).*scale_factor(n);
        Ainterp = interp1(ttemp,Atemp ,tp)';
        Ivalid = find(~isnan(Ainterp));
        Ainterp(isnan(Ainterp)) = 0;
        
        Nperiod = ceil(1/(f0_corrected(n)/Fs));
    else
        Ainterp = Atemp;  
        Ivalid = find(~isnan(Ainterp));
        Nperiod = ceil(1/(Fmin/Fs));
    end
    
    if n == 1
        A_corrected(I:I+block-1) = Ainterp;
        
    else
        
        % Pull out one period of the new waveform
        if Nperiod > length(Ainterp)
            disp('oops');
        end
        Achunk = Ainterp(Ivalid(1):Ivalid(1)+Nperiod-1);
        factor = sum(abs(Achunk))*2;
        
        if all(bsxfun(@and, scale_factor(n-1:n) > 0.9999, scale_factor(n-1:n) < 1.0001))

        else

            % Start doing correlation
            max_acorr_amp = 0;
            max_acorr_shift = 0;

            for Nshift = -round(Nperiod/2)+ (1:Nperiod)

                % Calculate makeshift autocorrelation
                acorr = 1-sum(abs(Achunk - A_corrected((I:I+Nperiod-1) + Nshift + Ivalid(1))))./factor;

                if acorr > max_acorr_amp
                    max_acorr_amp = acorr;
                    max_acorr_shift = Nshift;
                end
            end
        end
        
        [what,where] = min(abs(Achunk - ...
            A_corrected((I:I+Nperiod-1) + max_acorr_shift + Ivalid(1))));
        
        if plot_on
            Asave = A_corrected((I:I+Nperiod-1) + max_acorr_shift + Ivalid(1));
        end
        
        A_corrected((I+where-1:I+length(Ivalid)-1) + max_acorr_shift + Ivalid(1)) = ...
            Ainterp(Ivalid(where:end));
        
        if plot_on
            tt = 1:length(Achunk);
            figure(1);
            plot(tt,Achunk,tt,Asave,tt,A_corrected((I:I+Nperiod-1) + max_acorr_shift + Ivalid(1)))
            title(sprintf('Acorr = %0.3f (Nshift = %i)',max_acorr_amp,max_acorr_shift))
            hold on
            plot(tt(where),Achunk(where),'*')
            hold off
            pause
        end

    end
    
    I = I+step;
%     if I > 50000
%         I;
%     end
end
