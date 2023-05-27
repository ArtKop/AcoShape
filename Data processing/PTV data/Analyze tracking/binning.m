function [rData,rCounts] = binning(data,minbinsize,alpha)

if (nargin < 3)
    alpha = 6;
end

mi = min(data(:,1:2));
ma = max(data(:,1:2));   
d = ma - mi;    
siz = floor(d / minbinsize)+1;    

bins = zeros(siz(1),siz(2),size(data,2));    
counts = zeros(siz(1),siz(2));    
for i = 1:siz(1)
    for j = 1:siz(2)            
        l = ([i j]-1) ./ siz .* d + mi;
        h = [i j] ./ siz .* d + mi; 
        ind = data(:,1) > l(1) & data(:,1) < h(1) & data(:,2) > l(2) & data(:,2) < h(2);
        % dtmp = data(ind,:);        
        % st = std(dtmp);
        % m = mean(dtmp);
        % res = dtmp - ones(size(dtmp,1),1) * m;
        % ind2 = all(res < alpha * ones(size(dtmp,1),1) * st,2);
        % bins(i,j,:) = mean(dtmp(ind2,:));        
        % counts(i,j) = sum(ind2);
        bins(i,j,:) = mean(data(ind,:));        
        counts(i,j) = sum(ind);
    end        
end

rData = reshape(bins,prod(siz),size(data,2));
rCounts = reshape(counts,prod(siz),1);
ind = rCounts > 0;
rData = rData(ind,:);
rCounts = rCounts(ind);