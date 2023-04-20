userIn = input("Type the sequence name: ", 's');
filename = strcat("sequences\sequence_", userIn, "_train.mat");
load(filename);
table = ones(20,10);

table(1,:) = sequence(1);

for i = 2:length(sequence)
    table(i, 1:9) = table (i-1, 2:10);
    table(i, 10) = sequence(i);
end

disp(strcat("Saving table in :: trainTables\table_", userIn, "_train.mat"));
save(strcat("trainTables\table_", userIn, "_train.mat"), "table");