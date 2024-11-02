clear;

Upp = 26;
du = 19;
D = 250;

name = "data/zad2_step_value=" + string(Upp + du) + ".csv";
raw_data = load(name);

s = stepResponseNormalizedFromData(raw_data(:, 1), du, D);

plot(s);