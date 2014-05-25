function accuracy = RF_LOSOCV(feat, y, songList, songIDvector, numTrees)

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
    % Random Forest classifier 
    b = TreeBagger(numTrees,norm_feat(train,:),y(train),'SampleWithReplacement','off');
    y_predict = predict(b,norm_feat(test,:));
    for i = 1: length(y_predict)
        predicted(i) = str2num(y_predict{i});
    end
    % Compute the performance measures:
    accuracy(k) = numel(find(predicted == y(test)))/length(y(test))*100;
end

