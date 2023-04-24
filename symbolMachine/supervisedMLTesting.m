%% Supervised Machine Learning Models
% For now, this test script only contains components for a linear
% regression model of the test set.

% The predictive model will output the next expected symbol, at which point
% a non-uniform pdf (for now) will be assigned based on which symbol was
% predicted with a large weight towards the predicted value.

% In future iterations, the training portion (taken directly from,,
% SymbolMachineSuccessiveConditional.m) may be implemented to estimate the
% best variance level for the predicted symbol.

% As of now, training has been done solely on the DIAtemp dataset.

load("probMLModels\linRegModel.mat");
userIn = input("Enter the test sequence label: ", 's');

%% Training Portion of symbol machine

minVal = 0.65;
maxVal = 0.75;
step = (maxVal - minVal) / 10;

penalties = zeros(1, 11);
accuracy = zeros(1, 11);

bestVar = 0.1;
bestPenalty = realmax; %initalize best penalty to max number
for varFactor = minVal:step:maxVal
    sequenceLength = initializeSymbolMachine(strcat('sequences\sequence_', userIn, '_train.mat'));
    global SYMBOLDATA
    
    varVal = varFactor;
    table = ones(1,9);
    count = ones(1,9);

    [symbol, penalty] = symbolMachine(ones(9,1) / 9); % The algorithm can't make a prediction with no data
    table(1,:) = symbol;
    count(symbol) = count(symbol) + 1;

    for i = 2:sequenceLength
        predicted = round(regrModel.predictFcn(table));
        probs = (1/sqrt(2*pi*varVal)) .* exp((-1 .* ((1:9) - predicted(end)).^ 2) / (2 * varVal));
        probs = probs / sum(probs);

        [symbol, penalty] = symbolMachine(probs);
        table(i, 1:8) = table(i-1, 2:9);
        table(i, 9) = symbol;
        count(symbol) = count(symbol) + 1;
    end

    % 4. Run 'report symbol machine'
    % reportSymbolMachine;
    if SYMBOLDATA.totalPenaltyInBits < bestPenalty
        bestVar = varFactor;
        bestPenalty = SYMBOLDATA.totalPenaltyInBits;
    end
    index = round((varFactor - minVal) / step + 1);
    penalties(index) = SYMBOLDATA.totalPenaltyInBits;
    accuracy(index) = 100 * SYMBOLDATA.correctPredictions/SYMBOLDATA.sequenceLength;
    disp("Testing varFactor: " + varFactor + ". Percent Guessed Correct: " + 100*SYMBOLDATA.correctPredictions/SYMBOLDATA.sequenceLength + ". Total Penalty: " + SYMBOLDATA.totalPenaltyInBits);
end
disp("Empirically Determined Best Bias Factor: " + bestVar)

figure(1); clf;
subplot(1,2,1);
plot(minVal:step:maxVal, penalties, 'b-');
title("Penalties");
subplot(1,2,2);
plot(minVal:step:maxVal, accuracy, 'r-');
title("Accuracy");

%% Testing Linear Regression Model with round() and Preset Nonuniform Dist

load("probMLModels\linRegModel.mat");
sequenceLength = initializeSymbolMachine(strcat('sequences\sequence_', userIn, '_test.mat'));

varVal = bestVar;
initProbVal = (ones(9,1) - varVal) / 8;
table = ones(1,9);
count = ones(1,9);

[symbol, penalty] = symbolMachine(ones(9,1) / 9); % The algorithm can't make a prediction with no data
table(1,:) = symbol;
count(symbol) = count(symbol) + 1;

for i = 2:sequenceLength
    predicted = round(regrModel.predictFcn(table));
    probs = (1/sqrt(2*pi*varVal)) .* exp((-1 .* ((1:9) - predicted(end)).^ 2) / (2 * varVal));
    probs = probs / sum(probs);

    [symbol, penalty] = symbolMachine(probs);
    table(i, 1:8) = table(i-1, 2:9);
    table(i, 9) = symbol;
    count(symbol) = count(symbol) + 1;
end
reportSymbolMachine;


%% Testing Neural Regression Model with round() and Preset Nonuniform Dist

% load("probMLModels\triNeuralReg.mat");
% userIn = input("Enter the test sequence label: ", 's');
% sequenceLength = initializeSymbolMachine(strcat('sequences\sequence_', userIn, '_test.mat'));
% 
% %global SYMBOLDATA
% varVal = 0.9;
% initProbVal = (ones(9,1) - varVal) / 8;
% counts = zeros(1,9);
% predTable = zeros(1,18);
% 
% [symbol, penalty] = symbolMachine(ones(9,1) / 9); % The algorithm can't make a prediction with no data
% counts(symbol) = counts(symbol) + 1;
% predTable(1,10:18) = symbol;
% 
% for i = 2:sequenceLength
%     predicted = round(triNeuralReg.predictFcn(predTable));
%     if(predicted(end) > 9) predicted(end) = 9; end
%     if(predicted(end) < 0) predicted(end) = 0; end
% 
%     probs = initProbVal;
%     probs(predicted(end)) = varVal;
%     
%     [symbol, penalty] = symbolMachine(probs);
% 
%     counts(symbol) = counts(symbol) + 1;
%     predTable(i, 1:9) = counts / sum(counts);
% 
%     predTable(i, 10:17) = predTable(i-1, 11:18);
%     predTable(i, 18) = symbol;
% end
% reportSymbolMachine;

%%