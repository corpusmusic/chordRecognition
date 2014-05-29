function c = initFeatureExtractionMA(dummy)


%% CONSTANTS FOR FEATURE EXTRACTION

num_ceps_coeffs = 20;
c.fs = 44100;
c.num_filt = 36; %% number of Mel frequency bands
c.seg_size = 512; %% 23ms if c.fs == 22050Hz
c.hop_size = 512;

f = linspace(0,c.fs/2,c.seg_size/2+1); %% frequency bins of P
mel = log(1+f/700)*1127.01048;
mel_idx = linspace(0,mel(end),c.num_filt+2);

f_idx = zeros(c.num_filt+2,1);
for i=1:c.num_filt+2,
    [tmp f_idx(i)] = min(abs(mel - mel_idx(i)));
end
freqs = f(f_idx);

%% height of triangles
h = 2./(freqs(3:c.num_filt+2)-freqs(1:c.num_filt));

c.mel_filter = zeros(c.num_filt,c.seg_size/2+1);
for i=1:c.num_filt,
    c.mel_filter(i,:) = ...
        (f > freqs(i) & f <= freqs(i+1)).* ...
        h(i).*(f-freqs(i))/(freqs(i+1)-freqs(i)) + ...
        (f > freqs(i+1) & f < freqs(i+2)).* ...
        h(i).*(freqs(i+2)-f)/(freqs(i+2)-freqs(i+1));
end

c.DCT = 1/sqrt(c.num_filt/2) * ...
    cos((0:num_ceps_coeffs-1)'*(0.5:c.num_filt)*pi/c.num_filt);
c.DCT(1,:) = c.DCT(1,:)*sqrt(2)/2;
c.w = 0.5*(1-cos(2*pi*(0:c.seg_size-1)/(c.seg_size-1)))';

%% FP constants
c.trans = [1 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 9 9 ...
    10 10 10 10 10 11 11 11 11 11 11 ...
    12 12 12 12 12 12 12];
c.f = 22050/512/2*(0:64)/64;
c.flux_w = repmat(1./(c.f(2:32)/4+4./c.f(2:32)),12,1);  %% see zwicker book p. 254
c.gauss_w = [.05 .1 .25 .5 1 .5 .25 .1 .05];
c.blur = filter2(c.gauss_w,eye(12));
c.blur = c.blur./repmat(sum(c.blur,2),1,12);
c.blur2 = filter2(c.gauss_w,eye(30));
c.blur2 = (c.blur2./repmat(sum(c.blur2,2),1,30))';

end
