%Symbol machine use directions:
%Training part, determine best value for initProbVal as proportion of
%overall dataset size
%1. initialize the symbol machine, setting global variables for overall
%sequence, using below code. Set input file to parameter of init function


%2. For this method, will be estimating the conditional probabilities for a
%number based on the number previous. Data structure will be 2d array,
%1 array containing probability distributions for a giving prior number

%% Training Portion of symbol machine

sequenceName = 'nonuniform'; % use this line to select name of sequence to analyze, text in between _'text'_ in sequence files

bestInitFactor = 0.1;
bestPenalty = realmax; %initalize best penalty to max number
initFactors = [];
initFactorPenalties = [];
for initFactor = cat(2, 0:0.001:0.009, 0.01:0.01:0.09 , 0.1:0.1:2) 
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
        sums(lastKnownSymbol, symbol) = sums(lastKnownSymbol, symbol) + 1;
    end
    %4. Run 'report symbol machine
    %reportSymbolMachine;
    initFactors = [initFactors, initProbVal];
    initFactorPenalties = [initFactorPenalties, SYMBOLDATA.totalPenaltyInBits];

    if SYMBOLDATA.totalPenaltyInBits < bestPenalty
        bestInitFactor = initFactor;
        bestPenalty = SYMBOLDATA.totalPenaltyInBits;
    end
    disp("Testing initFactor: " + initFactor + ". Percent Guessed Correct: " + 100*SYMBOLDATA.correctPredictions/SYMBOLDATA.sequenceLength + ". Total Penalty: " + SYMBOLDATA.totalPenaltyInBits);
end
disp("Empirically Determined Best Init Factor: " + ceil(sequenceLength/9*bestInitFactor)+1)

plot(initFactors, initFactorPenalties);
title('Penalty vs. Initialization Factor - Nonuniform training data');
xlabel('Initialization Factors');
ylabel('Total Penalty (in bits)');
ax = gca; 
ax.FontSize = 18; 


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
    sums(lastKnownSymbol, symbol) = sums(lastKnownSymbol, symbol) + 1;
end
reportSymbolMachine;





