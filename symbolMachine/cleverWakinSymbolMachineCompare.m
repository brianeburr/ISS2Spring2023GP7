sequenceLength = initializeSymbolMachine('sequences\sequence_selfAdapt_train.mat');
symbolCounts = ones(1,9); 
for ii = 1:sequenceLength
    probs = symbolCounts/sum(symbolCounts);
    [thisSymbol,penalty] = symbolMachine(probs);
    symbolCounts(thisSymbol) = symbolCounts(thisSymbol) + 1;
end
reportSymbolMachine;

