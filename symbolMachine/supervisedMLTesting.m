%% Supervised Machine Learning Models
% For now, this test script only contains components for a linear
% regression model of the test set.

% The predictive model will output the next expected symbol, at which point
% a non-uniform pdf (for now) will be assigned based on which symbol was
% predicted with a large weight towards the predicted value.

% In future iterations, the training portion (taken directly from,,
% SymbolMachineSuccessiveConditional.m) may be implemented to estimate the
% best bias level for the predicted symbol.

% As of now, training has been done solely on the DIAtemp dataset.

load("probMLModels\linRegModel.mat");
userIn = input("Enter the test sequence label: ", 's');
sequenceLength = initializeSymbolMachine(strcat('sequences\sequence_', userIn, '_test.mat'));

%% Training Portion of symbol machine
 
% bestInitFactor = 0.1;
% bestPenalty = realmax; %initalize best penalty to max number
% for initFactor = cat(2, 0:0.01:0.09 , 0.1:0.1:2) 
%     sequenceLength = initializeSymbolMachine(strcat('sequences\sequence_', sequenceName, '_train.mat'));
%     initProbVal = ceil(sequenceLength/9*initFactor)+1; % initial value for probability distribution to be composed of, 
%     % assumes uniform distribution to start, prevents probability of zero,
%     % can be empirically tested to find best value
%     global SYMBOLDATA
%     sums = [[]];
%     for i = 1:9
%         for j = 1:9
%             sums(i,j) = initProbVal;
%         end
%     end
%     % 3. For each element in sequence, run 'symbolMachine(pmf for given
%     % situation)', accepting return tuple of symbol,penalty
%     probs = sums(1,:)/sum(sums(1,:));
%     [symbol,penalty] = symbolMachine(probs); %must run once before loop because of different functionality
%     for ii = 2:sequenceLength
%         lastKnownSymbol = SYMBOLDATA.sequence(ii-1);  %finds most recent symbol to index into props matrix, give conditional probabilities
%         probs = sums(lastKnownSymbol,:)/sum(sums(lastKnownSymbol,:));
%         [symbol,penalty] = symbolMachine(probs);
%         sums(lastKnownSymbol, symbol) = sums(lastKnownSymbol, symbol) + 1;
%     end
%     % 4. Run 'report symbol machine
%     % reportSymbolMachine;
%     if SYMBOLDATA.totalPenaltyInBits < bestPenalty
%         bestInitFactor = initFactor;
%         bestPenalty = SYMBOLDATA.totalPenaltyInBits;
%     end
%     disp("Testing initFactor: " + initFactor + ". Percent Guessed Correct: " + 100*SYMBOLDATA.correctPredictions/SYMBOLDATA.sequenceLength + ". Total Penalty: " + SYMBOLDATA.totalPenaltyInBits);
% end
% disp("Empirically Determined Best Init Factor: " + bestInitFactor)


%% Testing Linear Regression Model with round() and Preset Nonuniform Dist

% load("probMLModels\linRegModel.mat");
% userIn = input("Enter the test sequence label: ", 's');
% sequenceLength = initializeSymbolMachine(strcat('sequences\sequence_', userIn, '_test.mat'));
% 
% % global SYMBOLDATA
% biasVal = 0.9;
% initProbVal = (ones(9,1) - biasVal) / 8;
% table = ones(1,9);
% 
% [symbol, penalty] = symbolMachine(ones(9,1) / 9); % The algorithm can't make a prediction with no data
% table(1,:) = symbol;
% 
% for i = 2:sequenceLength
%     predicted = round(linRegModel.predictFcn(table));
%     probs = initProbVal;
%     probs(predicted(end)) = biasVal;
% 
%     [symbol, penalty] = symbolMachine(probs);
%     table(i, 1:8) = table(i-1, 2:9);
%     table(i, 9) = symbol;
% end
% reportSymbolMachine;


%% Testing Neural Regression Model with round() and Preset Nonuniform Dist

% load("probMLModels\triNeuralReg.mat");
% userIn = input("Enter the test sequence label: ", 's');
% sequenceLength = initializeSymbolMachine(strcat('sequences\sequence_', userIn, '_test.mat'));
% 
% %global SYMBOLDATA
% biasVal = 0.9;
% initProbVal = (ones(9,1) - biasVal) / 8;
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
%     probs(predicted(end)) = biasVal;
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