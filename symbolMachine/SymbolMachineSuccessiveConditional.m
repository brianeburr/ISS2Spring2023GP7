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

probs = [[]];
for i = 1:9
    for j = 1:9
        probs(i,j) = initProbVal;
    end
end

%3. For each element in sequence, run 'symbolMachine(pmf for given
%situation)', accepting return tuple of symbol,penalty
for ii = 1:sequenceLength
    %lastKnownSymbol = SYMBOLDATA.


    [symbol,penalty] = symbolMachine(probs);
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




