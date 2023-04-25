%% Sequence name/input

sequenceName = 'Dickens';

%% Training portion of symbol machine

bestScaleFactor = 0.1;
bestPenalty = realmax;

minVal = 0.0015;
maxVal = 0.0025;
step = (maxVal - minVal) / 20;

penalties = zeros(1, 11);

for scaleFactor = minVal:step:maxVal
    sequenceLength = initializeSymbolMachine(strcat('sequences\sequence_', sequenceName, '_train.mat'));
    weight = 1.06;
    layer1Scale = 1;
    layer2Scale = 0.27;
    layer3Scale = 0.34;
    init = 0.002;

    global SYMBOLDATA
    roundPenalty = 0;
    dists(1:27) = 0;
    counts = zeros(9,9,9,9) + init;
    symbol = symbolMachine(ones(9, 1) / 9);
    last3(1:3) = symbol;
    counts(last3(1),last3(2),last3(3),symbol) = counts(last3(1),last3(2),last3(3),symbol) + weight;

    for i = 2:sequenceLength
        dists(1:9) = sum(counts(last3(1), :, :, :), 1:3) / sum(counts(last3(1), :, :, :), 'all');
        dists(10:18) = sum(counts(last3(1), last3(2), :, :), 1:3) / sum(counts(last3(1), last3(2), :, :), 'all');
        dists(19:27) = sum(counts(last3(1), last3(2), last3(3), :), 1:3) / sum(counts(last3(1), last3(2), last3(3), :), 'all');

        dist(1:9) = layer1Scale * dists(1:9) + layer2Scale * dists(10:18) + layer3Scale * dists(19:27);
        dist(1:9) = dist(1:9) / sum(dist(1:9));
        symbol = symbolMachine(dist);

        counts(last3(1),last3(2),last3(3),symbol) = counts(last3(1),last3(2),last3(3),symbol) + weight;
        last3(2:3) = last3(1:2);
        last3(1) = symbol;
    end

    if SYMBOLDATA.totalPenaltyInBits < bestPenalty
        bestScaleFactor = scaleFactor;
        bestPenalty = SYMBOLDATA.totalPenaltyInBits;
    end
    index = round((scaleFactor - minVal) / step + 1);
    penalties(index) = SYMBOLDATA.totalPenaltyInBits;
    disp("Testing scaleFactor: " + scaleFactor + ". Percent Guessed Correct: " + 100*SYMBOLDATA.correctPredictions/SYMBOLDATA.sequenceLength + ". Total Penalty: " + SYMBOLDATA.totalPenaltyInBits);
end
disp("Empirically Determined Best Scale Factor: " + bestScaleFactor)

figure(1); clf;
plot(minVal:step:maxVal, penalties, 'b-');
title("Penalties");

%% Testing section, uses training from previous section

sequenceLength = initializeSymbolMachine(strcat('sequences\sequence_', sequenceName, '_test.mat'));
weight = 1.06;
layer1Scale = 1;
layer2Scale = 0.27;
layer3Scale = 0.34;
init = 0.002;

dists(1:27) = 0;
counts = zeros(9,9,9,9) + init;
symbol = symbolMachine(ones(9, 1) / 9);
last3(1:3) = symbol;
counts(last3(1),last3(2),last3(3),symbol) = counts(last3(1),last3(2),last3(3),symbol) + weight;

for i = 2:sequenceLength
    dists(1:9) = sum(counts(last3(1), :, :, :), 1:3) / sum(counts(last3(1), :, :, :), 'all');
    dists(10:18) = sum(counts(last3(1), last3(2), :, :), 1:3) / sum(counts(last3(1), last3(2), :, :), 'all');
    dists(19:27) = sum(counts(last3(1), last3(2), last3(3), 1:9), 1:3) / sum(counts(last3(1), last3(2), last3(3), :), 'all');

    dist(1:9) = layer1Scale * dists(1:9) + layer2Scale * dists(10:18) + layer3Scale * dists(19:27);
    dist(1:9) = dist(1:9) / sum(dist(1:9));
    symbol = symbolMachine(dist);

    counts(last3(1),last3(2),last3(3),symbol) = counts(last3(1),last3(2),last3(3),symbol) + weight;
    last3(2:3) = last3(1:2);
    last3(1) = symbol;
end
reportSymbolMachine;
