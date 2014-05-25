clear all;
filename = '/Users/esthervasiete/Dropbox/Computational musicology/chordRecognition/all_chords.csv';
songList = [61 473 525 681 727 852 945];
songListData = getData(filename, songList);
%%
audioFilePath = '/Users/esthervasiete/Dropbox/Computational musicology/audioFiles/';
[feat y songID] = getFeatures(audioFilePath, songListData, songList);

%%
kNN = 50;
accuracy = KNN_LOSOCV(feat, y, songList, songID, kNN);
numTrees = 100;
accuracy = RF_LOSOCV(feat, y, songList, songID, numTrees);