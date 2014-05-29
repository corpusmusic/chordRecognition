function accuracy = LR_LOSOCV(feat, y, songList, songIDvector)

for k=1:length(songList)
    predicted = [];
    train = find(songIDvector ~= songList(k));
    test = find(songIDvector == songList(k));
     test_hist = hist(y(test),[0:13]);
    train_hist = hist(y(train),[0:13]);
    fair_test = [];
    for i = 1: length(test_hist)
        if test_hist(i) > 0 && train_hist(i) > 0 %% testing chords are available on the training set
            fair_test = [fair_test find(y(test) == (i - 1))];
        end
    end
    % Normalize
    MEAN = mean(feat(train,:));
    STD = std(feat(train,:));
    for sample = 1: length(feat)
        norm_feat(sample,:) = (feat(sample,:) - MEAN)./STD;
    end
    norm_feat(find(isnan(norm_feat))) = 0;
    % Logistic Regression classifier 
    B = mnrfit(norm_feat(train,:),y(train)+1);
    output = mnrval(B,norm_feat(fair_test,:));
    for i = 1: length(y(fair_test))
        [val predicted(i)] = max(output(i,:));
    end

    % Compute the performance measures:
    accuracy(k) = numel(find(predicted == (y(fair_test)+1)))/length(y(fair_test))*100;
end

