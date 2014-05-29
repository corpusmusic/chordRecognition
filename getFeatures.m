function [featAAL featMAT featCT y songID] = getFeatures(audioFilePath, data, songList)

srcFiles = dir(strcat(audioFilePath,'*.wav'));  % the folder in which audio files exist
numSongs = length(songList);

Ns = 0; %Number of samples
songID = [];
featAAL = []; featMAT = []; featCT = [];


win = 0.100; step = 0.050;
mtWin = 4.0; mtStep = 2.0;
mtWinRatio = mtWin / win; 
mtStepRatio =  mtStep / step;
Statistics = {'mean','median','std','stdbymean','max','min','meanNonZero','medianNonZero'};
c = initFeatureExtractionMA(1); 

for song = 1: numSongs
    song
    audioFile = strcat(audioFilePath,srcFiles(song).name);
    info = audioinfo(audioFile);
    fs = info.SampleRate;
    Y = audioread(audioFile);
    temp = data(find(data(:,1) == songList(song)),:);
    
    for sample_chord = 1: size(temp,1)
        Ns = Ns + 1;
        audio_chord_signal = Y(ceil(fs*temp(sample_chord,2)) : floor(fs*temp(sample_chord,3)),:);
        % short-term feature extraction:
        stF = stFeatureExtraction(audio_chord_signal, fs, win, step);              
        % mid-term feature statistic calculation:
        mtFeatures = mtFeatureExtraction(stF, mtWinRatio, mtStepRatio, Statistics);
        % long term averaging of the mid-term statistics:
        featAAL(Ns,:) = mean(mtFeatures,2);
        audio_chord_signal = (sum(audio_chord_signal,2)/2); % convert to MONO
        featMAT(Ns,:) = featureExtractionMA(audio_chord_signal', c);
        featCT(Ns,:) = featureExtractionCT(audio_chord_signal);
        y(Ns) = temp(sample_chord,4);
    end
    songID = [songID songList(song)*ones(1,length(temp))];
    temp = []; 
end