%Symbol machine use directions:

%1. initialize the symbol machine, setting global variables for overall
%sequence, using below code. Set input file to parameter of init function
sequenceLength = initializeSymbolMachine('sequence_nonuniform_train.mat');

%2. Generate probability distribution, this can be done in many ways, but
%normalization property of pmf must be observed
probs = ones(1,9)/9;

%3. For each element in sequence, run 'symbolMachine(pmf for given
%situation)', accepting return tuple of symbol,penalty
for ii = 1:sequenceLength
    [symbol,penalty] = symbolMachine(probs);
end

%4. Run 'report symbol machine
reportSymbolMachine;


