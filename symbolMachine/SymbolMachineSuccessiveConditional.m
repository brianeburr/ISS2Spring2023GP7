%Symbol machine use directions:
%Training part, determine best value for initProbVal as proportion of
%overall dataset size
%1. initialize the symbol machine, setting global variables for overall
%sequence, using below code. Set input file to parameter of init function


%2. For this method, will be estimating the conditional probabilities for a
%number based on the number previous. Data structure will be 2d array,
%1 array containing probability distributions for a giving prior number

%% Training Portion of symbol machine

sequenceName = 'DIAtemp'; % use this line to select name of sequence to analyze, text in between _'text'_ in sequence files

bestInitFactor = 0;
bestAddFactor = 1;
bestPenalty = realmax; %initalize best penalty to max number
initFactor = 0;
for addFactor = cat(2, 1:0.2:10) 
    sequenceLength = initializeSymbolMachine(strcat('sequences\sequence_', sequenceName, '_train.mat'));
    initProbVal = ceil(sequenceLength/9*initFactor)+1; % initial value for probability distribution to be composed of, 
    % assumes uniform distribution to start, prevents probability of zero,
    % can be empirically tested to find best value
    global SYMBOLDATA
    sums = [[]];
    for i = 1:9
        for j = 1:9
            sums(i,j) = initProbVal;
        end
    end
    %3. For each element in sequence, run 'symbolMachine(pmf for given
    %situation)', accepting return tuple of symbol,penalty
    probs = sums(1,:)/sum(sums(1,:));
    [symbol,penalty] = symbolMachine(probs); %must run once before loop because of different functionality
    for ii = 2:sequenceLength
        lastKnownSymbol = SYMBOLDATA.sequence(ii-1);  %finds most recent symbol to index into props matrix, give conditional probabilities
        probs = sums(lastKnownSymbol,:)/sum(sums(lastKnownSymbol,:));
        [symbol,penalty] = symbolMachine(probs);
        sums(lastKnownSymbol, symbol) = sums(lastKnownSymbol, symbol) + addFactor;
    end
    %4. Run 'report symbol machine
    %reportSymbolMachine;
    if SYMBOLDATA.totalPenaltyInBits < bestPenalty
        bestAddFactor = addFactor;
        bestPenalty = SYMBOLDATA.totalPenaltyInBits;
    end
    disp("Testing addFactor: " + addFactor + ". Percent Guessed Correct: " + 100*SYMBOLDATA.correctPredictions/SYMBOLDATA.sequenceLength + ". Total Penalty: " + SYMBOLDATA.totalPenaltyInBits);
end
disp("Empirically Determined Best add Factor: " + bestAddFactor)



%% Testing section, uses training from previous section
sequenceLength = initializeSymbolMachine(strcat('sequences\sequence_', sequenceName, '_test.mat'));
initProbVal = ceil(sequenceLength/9*bestInitFactor)+1; % initial value for probability distribution to be composed of, 
global SYMBOLDATA
sums = [[]];
for i = 1:9
    for j = 1:9
        sums(i,j) = initProbVal;
    end
end
probs = sums(1,:)/sum(sums(1,:));
[symbol,penalty] = symbolMachine(probs); %must run once before loop because of different functionality
for ii = 2:sequenceLength
    lastKnownSymbol = SYMBOLDATA.sequence(ii-1);  %finds most recent symbol to index into props matrix, give conditional probabilities
    probs = sums(lastKnownSymbol,:)/sum(sums(lastKnownSymbol,:));
    [symbol,penalty] = symbolMachine(probs);
    sums(lastKnownSymbol, symbol) = sums(lastKnownSymbol, symbol) + bestAddFactor;
end
reportSymbolMachine;





