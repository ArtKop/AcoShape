function [area] = calc_area(B,N,A) 

% return the total area encircled by the shape boundaries:
% B = the shape boundaries, N = the number of shapes found,
% A = the adjacency matrix of B

area = 0; % starting point
% loop through object boundaries  
for k = 1:N
    % boundary k is the parent of a hole if the k-th column 
    % of the adjacency matrix A contains a non-zero element 
    if (nnz(A(:,k)) > 0) 
        boundary = B{k};
        area = area + polyarea(boundary(:,2),boundary(:,1));
        % loop through the children of boundary k to exclude
        % the areas of holes inside the patterns
        for l = find(A(:,k))' 
            boundary = B{l};
            area = area - polyarea(boundary(:,2),boundary(:,1));
        end
    else
        boundary = B{k};
        area = area + polyarea(boundary(:,2),boundary(:,1));
    end
end
end
