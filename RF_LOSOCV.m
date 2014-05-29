function accuracy = RF_LOSOCV(feat, y, songList, songIDvector, numTrees)

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
    % Random Forest classifier 
    b = TreeBagger(numTrees,norm_feat(train,:),y(train),'SampleWithReplacement','off','NVarToSample',30);
    view(b.Trees{1})
    view(b.Trees{2})
    view(b.Trees{3})
    y_predict = predict(b,norm_feat(fair_test,:));
    for i = 1: length(y_predict)
        predicted(i) = str2num(y_predict{i});
    end
    % Compute the performance measures:
    accuracy(k) = numel(find(predicted == y(fair_test)))/length(y(fair_test))*100;
end

