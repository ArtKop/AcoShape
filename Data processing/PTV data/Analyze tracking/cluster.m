function [ret,w] = cluster(data,n)

rng(0,'twister');
[idx,ret] = kmeans(data,n,'MaxIter',50);
w = zeros(size(ret,1),1);
for i = 1:size(ret,1)
    w(i) = sum(idx == i);
end