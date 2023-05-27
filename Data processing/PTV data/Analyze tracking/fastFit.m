function fit = fastFit(x,y,z,Span,w)

    if (nargin >= 5)
        data = [x(:) y(:) z(:) w(:)];
    else
        data = [x(:) y(:) z(:)];        
    end
    mi = min(data(:,1:2));
    ma = max(data(:,1:2));   
    d = ma - mi;    
    nbins = floor((ma - mi) / Span)+1;    
    bins = cell(nbins);
    
    for i = 1:nbins(1)
        for j = 1:nbins(2)
            l = ([i j]-2) ./ nbins .* d + mi;
            h = ([i j]+1) ./ nbins .* d + mi;            
            ind = data(:,1) > l(1) & data(:,1) < h(1) & data(:,2) > l(2) & data(:,2) < h(2);
            bindata = data(ind,:);
            
            if (size(bindata,1) == 0)
                bins{i,j} = @(x,y) zeros(size(x));
                continue;
            end
            if (nargin >= 5)
                bins{i,j} = makefit(bindata(:,1),bindata(:,2),bindata(:,3),Span,bindata(:,4));
            else
                bins{i,j} = makefit(bindata(:,1),bindata(:,2),bindata(:,3),Span);
            end            
        end
    end
    
    fit = @fittedFunction;
    
    function ret = fittedFunction(x,y)
        ret = zeros(size(x));
        for k = 1:numel(ret)
            [ii,jj] = findBin(x(k),y(k));
            fitf = bins{ii,jj};
            ret(k) = fitf(x(k),y(k));
        end
    end

    function [i,j] = findBin(x,y)
        c = floor(([x y]-mi) ./ d .* nbins + 1);
        i = min(max(c(1),1),nbins(1));
        j = min(max(c(2),1),nbins(2));        
    end
end