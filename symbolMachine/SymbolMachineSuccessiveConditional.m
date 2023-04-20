%Symbol machine use directions:

%1. initialize the symbol machine, setting global variables for overall
%sequence, using below code. Set input file to parameter of init function
sequenceLength = initializeSymbolMachine('sequence_nonuniform_train.mat');

%2. For this method, will be estimating the conditional probabilities for a
%number based on the number previous. Data structure will be 2d array,
%1 array containing probability distributions for a giving prior number


initProbVal = sequenceLength/9/2; % initial value for probability distribution to be composed of, 
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

probs = sums(0)/sum(sums(0));

[symbol,penalty] = symbolMachine(probs(1)); %must run once before loop because of different functionality
for ii = 2:sequenceLength
    lastKnownSymbol = SYMBOLDATA.sequence(ii-1);  %finds most recent symbol to index into props matrix, give conditional probabilities
    probs = sums(lastKnownSymbol)/sum(sums(lastKnownSymbol));
    [symbol,penalty] = symbolMachine(probs);
    sums(lastKnownSymbol, symbol) = sums(lastKnownSymbol, symbol) + 1;
end

%4. Run 'report symbol machine
reportSymbolMachine;

%{
H = [[]]; %rows are first char, cols are second
for i = 1:27
    for j = 1:27
        H(i,j) = 0;
    end
end

for i = 1:length(A)-1
   firstChar = A(i);
   secondChar = A(i+1);
   H(secondChar, firstChar) = H(secondChar, firstChar) + 1;
end
H = H/length(A);
%}




