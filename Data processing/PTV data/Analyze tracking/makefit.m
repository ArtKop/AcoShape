function [ret,gof] = makefit(x,y,z,Span,w)

ft = fittype( 'loess' );
opts = fitoptions( 'Method', 'LowessFit' );
opts.Normalize = 'on';
opts.Robust = 'LAR';
opts.Span = Span;

if (nargin >= 5)
    opts.Weight = w;
end

[ret, gof] = fit( [x y],z, ft, opts);