function accuracy = KNN_LOSOCV(feat, y, songList, songIDvector, kNN)

for k=1:length(songList)
    predicted = [];
    train = find(songIDvector ~= songList(k));
    test = find(songIDvector == songList(k));
    % Normalize
    MEAN = mean(feat(train,:));
    STD = std(feat(train,:));
    for sample = 1: length(feat)
        norm_feat(sample,:) = (feat(sample,:) - MEAN)./STD;
    end
    norm_feat(find(isnan(norm_feat))) = 0;
    % K-nearest-neighbor classifier
    predicted = knnclassify(norm_feat(test,:), norm_feat(train,:), y(train), kNN, 'euclidean');      
    % Compute the performance measures:
    accuracy(k) = numel(find(predicted' == y(test)))/length(y(test))*100;
end

