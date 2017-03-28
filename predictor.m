function predicted = predictor(emailname)
    emailname = emailname
    load('spamTrain.mat');

    fprintf('\nTraining Linear SVM (Spam Classification)\n')
    fprintf('(this may take 1 to 2 minutes) ...\n')
    C = 0.1;
%    model = svmTrain(X, y, C, @linearKernel);
%    save('file2save.mat','model');
    load('file2save.mat','model');
    p = svmPredict(model, X);

    fprintf('Training Accuracy: %f\n', mean(double(p == y)) * 100);

    load('spamTest.mat');

    fprintf('\nEvaluating the trained Linear SVM on a test set ...\n')

    p = svmPredict(model, Xtest);

    fprintf('Test Accuracy: %f\n', mean(double(p == ytest)) * 100);

    [weight, idx] = sort(model.w, 'descend');
    vocabList = getVocabList();

    fprintf('\nTop predictors of spam: \n');
    for i = 1:15
        fprintf(' %-15s (%f) \n', vocabList{idx(i)}, weight(i));
    end

    fprintf('\n\n');

    file_contents = readFile(emailname);
    word_indices  = processEmail(file_contents);
    x             = emailFeatures(word_indices);
    p = svmPredict(model, x);

    fprintf('\nProcessed %s\n\nSpam Classification: %d\n', emailname, p);
    fprintf('(1 indicates spam, 0 indicates not spam)\n\n');
    predicted = p
end
