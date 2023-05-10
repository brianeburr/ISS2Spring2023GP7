userIn = input("Type the sequence name: ", 's');
filename = strcat("sequences\sequence_", userIn, "_train.mat");
load(filename);

sequenceLength = initializeSymbolMachine(strcat('sequences\sequence_', sequenceName, '_test.mat'));
weight = 1.06;
layer1Scale = 1;
layer2Scale = 0.27;
layer3Scale = 0.34;
init = 0.002;

dists(1:27) = 0;
counts = ones(9,9,9,9) / 81;
last3(1:3) = sequence(1);
counts(last3(1),last3(2),last3(3),sequence(1)) = counts(last3(1),last3(2),last3(3),sequence(1)) + weight;

for i = 2:length(sequence)
    dists(1:9) = sum(counts(last3(1), :, :, :), 1:3) / sum(counts(last3(1), :, :, :), 'all');
    dists(10:18) = sum(counts(last3(1), last3(2), :, :), 1:3) / sum(counts(last3(1), last3(2), :, :), 'all');
    dists(19:27) = sum(counts(last3(1), last3(2), last3(3), :), 1:3) / sum(counts(last3(1), last3(2), last3(3), :), 'all');

%     dist(1:9) = layer1Scale * dists(1:9) + layer2Scale * dists(10:18) + layer3Scale * dists(19:27);
%     dist(1:9) = dist(1:9) / sum(dist(1:9));

    counts(last3(1),last3(2),last3(3),sequence(i)) = counts(last3(1),last3(2),last3(3),sequence(i)) + weight;
    last3(2:3) = last3(1:2);
    last3(1) = sequence(i);
end

% disp(sum(sequence == 1:9));
% out(1:9) = sum(counts(:, :, :, 1:9), 1:3);
% disp(out - 1);

disp(strcat("Saving trainTable in :: trainTables\trainTable_", userIn, "_train.mat"));
save(strcat("trainTables\trainTable_", userIn, "_train.mat"), "dists");