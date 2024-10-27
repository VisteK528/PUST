function s = stepResponseNormalizedFromData(data, du, D)
    Ypp = data(1);
    data = data(1:D);

    s = (data - Ypp * ones(1, D)) / du;
end