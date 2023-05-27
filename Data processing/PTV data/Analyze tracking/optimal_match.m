function [m,dist] = optimal_match(p1,p2,threshold)
    [X1,X2] = meshgrid(p1(:,1),p2(:,1));
    [Y1,Y2] = meshgrid(p1(:,2),p2(:,2));
    D = sqrt((X1 - X2) .^ 2 + (Y1 - Y2) .^ 2);
    if (nargin >= 3)
        D(D(:) > threshold) = inf;
    end
    if (size(D,1) > size(D,2))
        assignment = munkres(D');
        m = [(1:length(assignment))' assignment'];
        m = m(m(:,2) > 0,:);
    else
        assignment = munkres(D);        
        m = [assignment' (1:length(assignment))'];        
        m = m(m(:,1) > 0,:);
    end    
    dist = D(sub2ind(size(D),m(:,2),m(:,1)));
    [dist,ind] = sort(dist);
    m = m(ind,:);
end