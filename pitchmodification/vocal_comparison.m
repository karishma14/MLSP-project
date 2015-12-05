function [vector_m] = vocal_comparison(audio1, audio2)

aud1 = audio1{1};
aud2 = audio2{1};

minLength = min(size(aud1,2), size(aud2,2));
aud1 = aud1(:, 1:minLength);
aud2 = aud2(:, 1:minLength);


[singer_pitch, fit] = findBaseFrequency(aud1, 30, 100);

[user_pitch, fit] = findBaseFrequency(aud2, 30, 100);


%assume the duration of singing is same

t = size(singer_pitch,1);
vector_m = zeros(t,1);

for i = 1:1:t
    if user_pitch(i) ~= 0
        vector_m(i) = singer_pitch(i)/user_pitch(i);
    else
        vector_m(i) = 1;
    end
end

    