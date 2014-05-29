clear all;
% change filename path!!
filename = '/Users/Dropbox/Computational musicology/chordRecognition/all_chords.csv';
audioFilePath = '/Users/Dropbox/Computational musicology/audioFiles/';
songList = [61 473 525 681 727 852 945];
songListData = getData(filename, songList);
[featAAL featMAT featCT y songID] = getFeatures(audioFilePath, songListData, songList);

kNN = 20;
accuracyKNN = KNN_LOSOCV([featAAL featCT], y, songList, songID, kNN);

numTrees = 200;
accuracyRF = RF_LOSOCV([featAAL featCT], y, songList, songID, numTrees);

hiddenLayerSize = 300;
accuracyNN600 = NN_LOSOCV([featAAL featCT], y, songList, songID, hiddenLayerSize);
