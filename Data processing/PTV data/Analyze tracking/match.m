function m = match(p1,p2)
    [X1,X2] = meshgrid(p1(:,1),p2(:,1));
    [Y1,Y2] = meshgrid(p1(:,2),p2(:,2));
    D = sqrt((X1 - X2) .^ 2 + (Y1 - Y2) .^ 2);
    n = min(size(p1,1),size(p2,1));
    m = zeros(n,2);
    for k = 1:n
        [~,ind] = min(D(:));
        [i,j] = ind2sub(size(D),ind);
        m(k,:) = [j i];
        D(i,:) = inf;
        D(:,j) = inf;
    end
end