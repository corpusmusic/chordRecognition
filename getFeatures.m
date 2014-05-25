function [feat y songID] = getFeatures(audioFilePath, data, songList)

srcFiles = dir(strcat(audioFilePath,'*.wav'));  % the folder in which audio files exist
numSongs = length(songList);

Ns = 0; %Number of samples
songID = [];

win = 0.050; step = 0.025;
mtWin = 2.0; mtStep = 1.0;
mtWinRatio = mtWin / win; 
mtStepRatio =  mtStep / step;
Statistics = {'mean','median','std','stdbymean','max','min','medianNonZero','meanNonZero'};

for song = 1: numSongs
    audioFile = strcat(audioFilePath,srcFiles(song).name);
    info = audioinfo(audioFile);
    fs = info.SampleRate;
    Y = audioread(audioFile);
%     if info.SampleRate ~= c.fs % Convert sampling frequency if not 22khz 
%         Y = resample(Y,info.SampleRate,c.fs);
%     end 
    temp = data(find(data(:,1) == songList(song)),:);
    
    for sample_chord = 1: size(temp,1)
        Ns = Ns + 1;
        audio_chord_signal = Y(ceil(fs*temp(sample_chord,2)) : floor(fs*temp(sample_chord,3)),:);
        % short-term feature extraction:
        stF = stFeatureExtraction(audio_chord_signal, fs, win, step);              
        % mid-term feature statistic calculation:
        mtFeatures = mtFeatureExtraction(stF, mtWinRatio, mtStepRatio, Statistics);
        % long term averaging of the mid-term statistics:
        feat(Ns,:) = mean(mtFeatures,2);
        y(Ns) = temp(sample_chord,4);
    end
    songID = [songID songList(song)*ones(1,length(temp))];
    temp = []; 
end