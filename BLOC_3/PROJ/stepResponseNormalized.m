function y = stepResponseNormalized(Upp, Ypp, du, n)
    y = stepResponse(Upp, Ypp, du, n);
    y = (y - ones(1, n) * Ypp) / du;
end