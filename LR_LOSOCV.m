function accuracy = LR_LOSOCV(feat, y, songList, songIDvector)

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
    % Logistic Regression classifier 
    B = mnrfit(norm_feat(train,:),y(train)+1);
    output = mnrval(B,norm_feat(test,:));
    for i = 1: length(y(test))
        [val predicted(i)] = max(output(i,:));
    end

    % Compute the performance measures:
    accuracy(k) = numel(find(predicted == (y(test)+1)))/length(y(test))*100;
end

