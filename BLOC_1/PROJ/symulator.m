
N = 300;
u = zeros(1, N);
y = zeros(1, N);
jump = 2;

u(jump:N) = 1.1;
steps = 1:N;

for i=12:N
    y(i) = symulacja_obiektu6y_p1(u(i-10), u(i-11), y(i-1), y(i-2));
end

figure;
plot(steps, y);

figure;
plot(steps, u);