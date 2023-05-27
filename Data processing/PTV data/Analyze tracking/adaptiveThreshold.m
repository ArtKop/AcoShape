function bw = adaptiveThreshold(gray,alpha)            
    m = mean(gray(:));
    e2 = (double(gray) - m) .^ 2;   
    [s,i] = sort(e2(:));
    i2 = 1:length(i);
    c = cumsum(s) ./ (1:length(s))';
    alpha2 = alpha .^ 2;
    lasti = find(s < alpha2 * c,1,'last');
    bw = logical(ones(size(gray)));
    bw(i2(i(1:lasti))) = 0;
end