function feat = featureExtractionMA(audio_signal, c)
%%
%%         G1C, implementation as described in thesis
%%         for mirex, "music audio search" (was audio music similarity)
%%
%% INPUT ARGUMENTS
%%
%% audio_signal: audio signal to extract features from
%%          all files are 22050Hz mono wav 

feat = [];
wav = audio_signal' * (10^(96/20)); %% Why??

%% compute P
num_segments = floor((length(wav)-c.seg_size)/c.hop_size)+1;
P = zeros(c.seg_size/2+1,num_segments); %% allocate memory

for i_p = 1:num_segments
    idx = (1:c.seg_size)+(i_p-1)*c.hop_size;
    x = abs(fft(wav(idx).*c.w)/sum(c.w)*2).^2;
    P(:,i_p) = x(1:end/2+1);
end


if 1, %% compute M dB
    M = zeros(c.num_filt,num_segments);

    for i_m = 1:num_segments,
        M(:,i_m) = c.mel_filter*P(:,i_m);
    end

    M(M<1)=1; M = 10*log10(M);
end

if 1, %% compute FP
    sone = zeros(12,size(M,2));
    for i_sone=1:12,
        sone(i_sone,:) = sum(M(c.trans==i_sone,:),1);
    end

    if size(sone,2)<128, %% pad with zeros (dont need this because MIREX files are all longer than 30sec)
        tmp_missing = 128-size(sone,2);
        sone = [zeros(size(sone,1),ceil(tmp_missing/2)), ...
            sone,zeros(size(sone,1),ceil(tmp_missing/2))];
    end

    num_fp_frames = floor((size(sone,2)-128)/64)+1;
    fp = zeros(num_fp_frames,12*30);

    idx = 1:128;
    for k=1:num_fp_frames,
        wsone = sone(:,idx);

        X = fft(wsone,128,2);
        X2 = abs(X(:,2:32)).*c.flux_w; %% amplitude spectrum (not power) 
        X3 = c.blur*abs(diff(X2,1,2))*c.blur2;

        fp(k,:) = X3(:)';
        idx = idx + 64;
    end
    fp = median(fp,1);
    feat = [feat fp];
end

tmp = reshape(fp,12,30);
fpg = sum(sum(tmp,1).*(1:30))/max(sum(tmp(:)),eps);
feat(end + 1) = fpg;
fp_bass = sum(sum(tmp(1:2,3:30))); %% modulation > 1Hz
feat(end + 1) = fp_bass;

mfcc = c.DCT * M;
mfcc = mfcc(2:20,:);
feat = [feat mean(mfcc,2)'];
feat = [feat max(pinv(squeeze(cov(mfcc'))))];


