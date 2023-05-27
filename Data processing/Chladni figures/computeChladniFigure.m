function [ret,modes,apsi] = computeChladniFigure(knorm,gamma,N,doplot,modes)

if (nargin < 4)
   doplot = 0; 
end

if (nargin < 5)
   modes = {}; 
end


phi = @(x,y,n1,n2) (2 * cos(n1 * pi  * x) * cos(n2 * pi * y));

kn = @(n1,n2) (pi * sqrt(n1^2 + n2^2));

A = zeros(N/2+1,N/2+1);

for n1 = 0:2:N
    for n2 = 0:2:N        
        A(n1/2+1,n2/2+1) = phi(1 / 2,1 / 2,n1,n2) / ((knorm*pi)^2 - kn(n1,n2)^2 + 2*1i*gamma*knorm*pi);        
    end
end

totsum = sqrt(sum(sum(abs(A) .^ 2)));
c = A / totsum;

p = abs(c) .^ 2;

ret = - sum(sum(p .* log(p)));

if (~isempty(doplot) & doplot ~= 0)   
    if (~strcmp(doplot,'reuse'))
        figure;
    end
    x = linspace(0,1,600);
    y = linspace(0,1,600);
    [X,Y] = meshgrid(x,y);
    psi = zeros(size(X));
    if isempty(modes)
        modes = cell(N+1,N+1);
    end
    for n1 = 0:2:N
        for n2 = 0:2:N
            if isempty(modes{n1+1,n2+1})
                modes{n1+1,n2+1} = arrayfun(@(x,y) phi(x,y,n1,n2),X,Y);                
            end                        
            psi = psi + c(n1/2+1,n2/2+1) * modes{n1+1,n2+1};
        end
    end
    apsi = abs(psi);
    w = 20;
    image(255 ./ (0.5 + apsi * w))
%     image(apsi .^ 2 * 20)    
end