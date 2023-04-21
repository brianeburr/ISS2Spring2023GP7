userIn = input("Type the sequence name: ", 's');
filename = strcat("sequences\sequence_", userIn, "_train.mat");
load(filename);

trainTable = zeros(20,19);
counts = zeros(1,9);

counts(sequence(1)) = counts(sequence(1)) + 1;
trainTable(1,10:19) = sequence(1);

for i = 2:length(sequence)
    counts(sequence(i)) = counts(sequence(i)) + 1;
    trainTable(i, 1:9) = counts / sum(counts);

    trainTable(i, 10:18) = trainTable (i-1, 11:19);
    trainTable(i, 19) = sequence(i);
end

disp(strcat("Saving trainTable in :: trainTables\trainTable_", userIn, "_train.mat"));
save(strcat("trainTables\trainTable_", userIn, "_train.mat"), "trainTable");