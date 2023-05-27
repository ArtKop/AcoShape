close all
clear


load('all_data.mat') % Particle displacements
load('maps-2020-5.mat') % LOESS
load('NN-2020-5.mat') % Neural networks

data = all_analyzed_data{1};

net_mse = zeros(52,1);
poly11 = zeros(52,1);
poly22 = zeros(52,1);
poly33 = zeros(52,1);
poly44 = zeros(52,1);
poly55 = zeros(52,1);
poly66 = zeros(52,1);
poly77 = zeros(52,1);
poly88 = zeros(52,1);
poly99 = zeros(52,1);
poly1010 = zeros(52,1);
poly1111 = zeros(52,1);
poly1212 = zeros(52,1);
poly1313 = zeros(52,1);

warning off
for note = 1:52
    
    note
    
mode_data = data{1,note};
x = mode_data(:,1);
y = mode_data(:,2);
dx = mode_data(:,3)';
dy = mode_data(:,4)';

ind_v = 1:4:length(x);
k = 0;
ind_t = [];
for i = 1:length(x)
    tempIdx = find(ind_v == i);
    if isempty(tempIdx)
        k = k + 1;
        ind_t(k) = i;
    end
end
x_t = x(ind_t);
x_v = x(ind_v);
y_t = y(ind_t);
y_v = y(ind_v);
dx_t = dx(ind_t);
dx_v = dx(ind_v);
dy_t = dy(ind_t);
dy_v = dy(ind_v);

% n = 1;
% layer_mse = [];
% for layers = 14:20
%     inputs = [x_t y_t]';
%     [netX,~] = train_NN(layers,inputs,dx_t);
%     [netY,~] = train_NN(layers,inputs,dy_t);
%     Ex = sum((dx_v - netX([x_v y_v]')).^2)/length(x_v);
%     Ey = sum((dy_v - netY([x_v y_v]')).^2)/length(x_v);
%     layer_mse(n) = mean([Ex Ey]);
%     n = n + 1;
% end
% net_mse(note) = min(layer_mse);

mse = poly_11(x_t,y_t,dx_t,dy_t,x_v,y_v,dx_v,dy_v);
poly11(note) = mse;

mse = poly_22(x_t,y_t,dx_t,dy_t,x_v,y_v,dx_v,dy_v);
poly22(note) = mse;

mse = poly_33(x_t,y_t,dx_t,dy_t,x_v,y_v,dx_v,dy_v);
poly33(note) = mse;

mse = poly_44(x_t,y_t,dx_t,dy_t,x_v,y_v,dx_v,dy_v);
poly44(note) = mse;

mse = poly_55(x_t,y_t,dx_t,dy_t,x_v,y_v,dx_v,dy_v);
poly55(note) = mse;

mse = poly_66(x_t,y_t,dx_t,dy_t,x_v,y_v,dx_v,dy_v);
poly66(note) = mse;

mse = poly_77(x_t,y_t,dx_t,dy_t,x_v,y_v,dx_v,dy_v);
poly77(note) = mse;

mse = poly_88(x_t,y_t,dx_t,dy_t,x_v,y_v,dx_v,dy_v);
poly88(note) = mse;

mse = poly_99(x_t,y_t,dx_t,dy_t,x_v,y_v,dx_v,dy_v);
poly99(note) = mse;

mse = poly_1010(x_t,y_t,dx_t,dy_t,x_v,y_v,dx_v,dy_v);
poly1010(note) = mse;

mse = poly_1111(x_t,y_t,dx_t,dy_t,x_v,y_v,dx_v,dy_v);
poly1111(note) = mse;

mse = poly_1212(x_t,y_t,dx_t,dy_t,x_v,y_v,dx_v,dy_v);
poly1212(note) = mse;

mse = poly_1313(x_t,y_t,dx_t,dy_t,x_v,y_v,dx_v,dy_v);
poly1313(note) = mse;
end

figure
fontsize = 13;
mean_mse = [mean(poly11) mean(poly22) mean(poly33) mean(poly44) mean(poly55) mean(poly66) ...
    mean(poly77) mean(poly88) mean(poly99) mean(poly1010) mean(poly1111)];
plot(mean_mse,'r-o','MarkerSize',8,'LineWidth',2)
names = {'poly1','poly2','poly3','poly4','poly5','poly6','poly7',...
    'poly8','poly9','poly10','poly11'};
set(gca,'xtick',[1:13],'xticklabel',names)
% xlabel('$$\int_0^x\!\int_y dF(u,v)$$','Interpreter','latex');
ylabel('mean mse','FontSize',fontsize)
grid on

function [mse] = poly_11(x,y,dx,dy,xv,yv,dxv,dyv)
X = [ones(length(x),1) x y];
Y = dx';
k1 = inv(X'*X)*X'*Y;
Y = dy';
k2 = inv(X'*X)*X'*Y;

x = xv;
y = yv;
X = [ones(length(xv),1) x y];
Y = dxv';
mse_dy = sum((Y-X*k1).^2)/length(x);

Y = dyv';
mse_dx = sum((Y-X*k2).^2)/length(x);

mse = mean([mse_dx mse_dy]);
end

function [mse] = poly_22(x,y,dx,dy,xv,yv,dxv,dyv)
X = [ones(length(x),1) x y x.^2 x.*y y.^2];
Y = dx';
k1 = inv(X'*X)*X'*Y;
Y = dy';
k2 = inv(X'*X)*X'*Y;

x = xv;
y = yv;
X = [ones(length(x),1) x y x.^2 x.*y y.^2];
Y = dxv';
mse_dy = sum((Y-X*k1).^2)/length(x);

Y = dyv';
mse_dx = sum((Y-X*k2).^2)/length(x);

mse = mean([mse_dx mse_dy]);
end

function [mse] = poly_33(x,y,dx,dy,xv,yv,dxv,dyv)
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3];
Y = dx';
k1 = inv(X'*X)*X'*Y;
Y = dy';
k2 = inv(X'*X)*X'*Y;

x = xv;
y = yv;
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3];
Y = dxv';
mse_dy = sum((Y-X*k1).^2)/length(x);

Y = dyv';
mse_dx = sum((Y-X*k2).^2)/length(x);

mse = mean([mse_dx mse_dy]);
end

function [mse] = poly_44(x,y,dx,dy,xv,yv,dxv,dyv)
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3 x.^4 ...
    (x.^3).*y (x.^2).*(y.^2) x.*(y.^3) y.^4];
Y = dx';
k1 = inv(X'*X)*X'*Y;
Y = dy';
k2 = inv(X'*X)*X'*Y;

x = xv;
y = yv;
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3 x.^4 ...
    (x.^3).*y (x.^2).*(y.^2) x.*(y.^3) y.^4];
Y = dxv';
mse_dy = sum((Y-X*k1).^2)/length(x);

Y = dyv';
mse_dx = sum((Y-X*k2).^2)/length(x);

mse = mean([mse_dx mse_dy]);
end

function [mse] = poly_55(x,y,dx,dy,xv,yv,dxv,dyv)
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3 x.^4 ...
    (x.^3).*y (x.^2).*(y.^2) x.*(y.^3) y.^4 x.^5 (x.^4).*y (x.^3).*(y.^2)...
    (x.^2).*(y.^3) x.*(y.^4) y.^5];
Y = dx';
k1 = inv(X'*X)*X'*Y;
Y = dy';
k2 = inv(X'*X)*X'*Y;

x = xv;
y = yv;
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3 x.^4 ...
    (x.^3).*y (x.^2).*(y.^2) x.*(y.^3) y.^4 x.^5 (x.^4).*y (x.^3).*(y.^2)...
    (x.^2).*(y.^3) x.*(y.^4) y.^5];
Y = dxv';
mse_dy = sum((Y-X*k1).^2)/length(x);

Y = dyv';
mse_dx = sum((Y-X*k2).^2)/length(x);

mse = mean([mse_dx mse_dy]);
end

function [mse] = poly_66(x,y,dx,dy,xv,yv,dxv,dyv)
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3 x.^4 ...
    (x.^3).*y (x.^2).*(y.^2) x.*(y.^3) y.^4 x.^5 (x.^4).*y (x.^3).*(y.^2)...
    (x.^2).*(y.^3) x.*(y.^4) y.^5 x.^6 (x.^5).*y (x.^4).*(y.^2) (x.^3).*(y.^3)...
    (x.^2).*(y.^4) x.*(y.^5) y.^6];
Y = dx';
k1 = inv(X'*X)*X'*Y;
Y = dy';
k2 = inv(X'*X)*X'*Y;

x = xv;
y = yv;
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3 x.^4 ...
    (x.^3).*y (x.^2).*(y.^2) x.*(y.^3) y.^4 x.^5 (x.^4).*y (x.^3).*(y.^2)...
    (x.^2).*(y.^3) x.*(y.^4) y.^5 x.^6 (x.^5).*y (x.^4).*(y.^2) (x.^3).*(y.^3)...
    (x.^2).*(y.^4) x.*(y.^5) y.^6];
Y = dxv';
mse_dy = sum((Y-X*k1).^2)/length(x);

Y = dyv';
mse_dx = sum((Y-X*k2).^2)/length(x);

mse = mean([mse_dx mse_dy]);
end

function [mse] = poly_77(x,y,dx,dy,xv,yv,dxv,dyv)
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3 x.^4 ...
    (x.^3).*y (x.^2).*(y.^2) x.*(y.^3) y.^4 x.^5 (x.^4).*y (x.^3).*(y.^2)...
    (x.^2).*(y.^3) x.*(y.^4) y.^5 x.^6 (x.^5).*y (x.^4).*(y.^2) (x.^3).*(y.^3)...
    (x.^2).*(y.^4) x.*(y.^5) y.^6 x.^7 (x.^6).*y (x.^5).*(y.^2) (x.^4).*(y.^3)...
    (x.^3).*(y.^4) (x.^2).*(y.^5) x.*(y.^6) y.^7];
Y = dx';
k1 = inv(X'*X)*X'*Y;
Y = dy';
k2 = inv(X'*X)*X'*Y;

x = xv;
y = yv;
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3 x.^4 ...
    (x.^3).*y (x.^2).*(y.^2) x.*(y.^3) y.^4 x.^5 (x.^4).*y (x.^3).*(y.^2)...
    (x.^2).*(y.^3) x.*(y.^4) y.^5 x.^6 (x.^5).*y (x.^4).*(y.^2) (x.^3).*(y.^3)...
    (x.^2).*(y.^4) x.*(y.^5) y.^6 x.^7 (x.^6).*y (x.^5).*(y.^2) (x.^4).*(y.^3)...
    (x.^3).*(y.^4) (x.^2).*(y.^5) x.*(y.^6) y.^7];
Y = dxv';
mse_dy = sum((Y-X*k1).^2)/length(x);

Y = dyv';
mse_dx = sum((Y-X*k2).^2)/length(x);

mse = mean([mse_dx mse_dy]);
end

function [mse] = poly_88(x,y,dx,dy,xv,yv,dxv,dyv)
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3 x.^4 ...
    (x.^3).*y (x.^2).*(y.^2) x.*(y.^3) y.^4 x.^5 (x.^4).*y (x.^3).*(y.^2)...
    (x.^2).*(y.^3) x.*(y.^4) y.^5 x.^6 (x.^5).*y (x.^4).*(y.^2) (x.^3).*(y.^3)...
    (x.^2).*(y.^4) x.*(y.^5) y.^6 x.^7 (x.^6).*y (x.^5).*(y.^2) (x.^4).*(y.^3)...
    (x.^3).*(y.^4) (x.^2).*(y.^5) x.*(y.^6) y.^7 x.^8 (x.^7).*y (x.^6).*(y.^2)...
    (x.^5).*(y.^3) (x.^4).*(y.^4) (x.^3).*(y.^5) (x.^2).*(y.^6) x.*(y.^7) y.^8];
Y = dx';
k1 = inv(X'*X)*X'*Y;
Y = dy';
k2 = inv(X'*X)*X'*Y;

x = xv;
y = yv;
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3 x.^4 ...
    (x.^3).*y (x.^2).*(y.^2) x.*(y.^3) y.^4 x.^5 (x.^4).*y (x.^3).*(y.^2)...
    (x.^2).*(y.^3) x.*(y.^4) y.^5 x.^6 (x.^5).*y (x.^4).*(y.^2) (x.^3).*(y.^3)...
    (x.^2).*(y.^4) x.*(y.^5) y.^6 x.^7 (x.^6).*y (x.^5).*(y.^2) (x.^4).*(y.^3)...
    (x.^3).*(y.^4) (x.^2).*(y.^5) x.*(y.^6) y.^7 x.^8 (x.^7).*y (x.^6).*(y.^2)...
    (x.^5).*(y.^3) (x.^4).*(y.^4) (x.^3).*(y.^5) (x.^2).*(y.^6) x.*(y.^7) y.^8];
Y = dxv';
mse_dy = sum((Y-X*k1).^2)/length(x);

Y = dyv';
mse_dx = sum((Y-X*k2).^2)/length(x);

mse = mean([mse_dx mse_dy]);
end

function [mse] = poly_99(x,y,dx,dy,xv,yv,dxv,dyv)
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3 x.^4 ...
    (x.^3).*y (x.^2).*(y.^2) x.*(y.^3) y.^4 x.^5 (x.^4).*y (x.^3).*(y.^2)...
    (x.^2).*(y.^3) x.*(y.^4) y.^5 x.^6 (x.^5).*y (x.^4).*(y.^2) (x.^3).*(y.^3)...
    (x.^2).*(y.^4) x.*(y.^5) y.^6 x.^7 (x.^6).*y (x.^5).*(y.^2) (x.^4).*(y.^3)...
    (x.^3).*(y.^4) (x.^2).*(y.^5) x.*(y.^6) y.^7 x.^8 (x.^7).*y (x.^6).*(y.^2)...
    (x.^5).*(y.^3) (x.^4).*(y.^4) (x.^3).*(y.^5) (x.^2).*(y.^6) x.*(y.^7) y.^8 ...
    x.^9 (x.^8).*y (x.^7).*(y.^2) (x.^6).*(y.^3) (x.^5).*(y.^4) (x.^4).*(y.^5)...
    (x.^3).*(y.^6) (x.^2).*(y.^7) x.*(y.^8) y.^9];
Y = dx';
k1 = inv(X'*X)*X'*Y;
Y = dy';
k2 = inv(X'*X)*X'*Y;

x = xv;
y = yv;
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3 x.^4 ...
    (x.^3).*y (x.^2).*(y.^2) x.*(y.^3) y.^4 x.^5 (x.^4).*y (x.^3).*(y.^2)...
    (x.^2).*(y.^3) x.*(y.^4) y.^5 x.^6 (x.^5).*y (x.^4).*(y.^2) (x.^3).*(y.^3)...
    (x.^2).*(y.^4) x.*(y.^5) y.^6 x.^7 (x.^6).*y (x.^5).*(y.^2) (x.^4).*(y.^3)...
    (x.^3).*(y.^4) (x.^2).*(y.^5) x.*(y.^6) y.^7 x.^8 (x.^7).*y (x.^6).*(y.^2)...
    (x.^5).*(y.^3) (x.^4).*(y.^4) (x.^3).*(y.^5) (x.^2).*(y.^6) x.*(y.^7) y.^8 ...
    x.^9 (x.^8).*y (x.^7).*(y.^2) (x.^6).*(y.^3) (x.^5).*(y.^4) (x.^4).*(y.^5)...
    (x.^3).*(y.^6) (x.^2).*(y.^7) x.*(y.^8) y.^9];
Y = dxv';
mse_dy = sum((Y-X*k1).^2)/length(x);

Y = dyv';
mse_dx = sum((Y-X*k2).^2)/length(x);

mse = mean([mse_dx mse_dy]);
end

function [mse] = poly_1010(x,y,dx,dy,xv,yv,dxv,dyv)
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3 x.^4 ...
    (x.^3).*y (x.^2).*(y.^2) x.*(y.^3) y.^4 x.^5 (x.^4).*y (x.^3).*(y.^2)...
    (x.^2).*(y.^3) x.*(y.^4) y.^5 x.^6 (x.^5).*y (x.^4).*(y.^2) (x.^3).*(y.^3)...
    (x.^2).*(y.^4) x.*(y.^5) y.^6 x.^7 (x.^6).*y (x.^5).*(y.^2) (x.^4).*(y.^3)...
    (x.^3).*(y.^4) (x.^2).*(y.^5) x.*(y.^6) y.^7 x.^8 (x.^7).*y (x.^6).*(y.^2)...
    (x.^5).*(y.^3) (x.^4).*(y.^4) (x.^3).*(y.^5) (x.^2).*(y.^6) x.*(y.^7) y.^8 ...
    x.^9 (x.^8).*y (x.^7).*(y.^2) (x.^6).*(y.^3) (x.^5).*(y.^4) (x.^4).*(y.^5)...
    (x.^3).*(y.^6) (x.^2).*(y.^7) x.*(y.^8) y.^9 x.^10 (x.^9).*y (x.^8).*(y.^2)...
    (x.^7).*(y.^3) (x.^6).*(y.^4) (x.^5).*(y.^5) (x.^4).*(y.^6) (x.^3).*(y.^7)...
    (x.^2).*(y.^8) x.*(y.^9) y.^10];
Y = dx';
k1 = inv(X'*X)*X'*Y;
Y = dy';
k2 = inv(X'*X)*X'*Y;

x = xv;
y = yv;
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3 x.^4 ...
    (x.^3).*y (x.^2).*(y.^2) x.*(y.^3) y.^4 x.^5 (x.^4).*y (x.^3).*(y.^2)...
    (x.^2).*(y.^3) x.*(y.^4) y.^5 x.^6 (x.^5).*y (x.^4).*(y.^2) (x.^3).*(y.^3)...
    (x.^2).*(y.^4) x.*(y.^5) y.^6 x.^7 (x.^6).*y (x.^5).*(y.^2) (x.^4).*(y.^3)...
    (x.^3).*(y.^4) (x.^2).*(y.^5) x.*(y.^6) y.^7 x.^8 (x.^7).*y (x.^6).*(y.^2)...
    (x.^5).*(y.^3) (x.^4).*(y.^4) (x.^3).*(y.^5) (x.^2).*(y.^6) x.*(y.^7) y.^8 ...
    x.^9 (x.^8).*y (x.^7).*(y.^2) (x.^6).*(y.^3) (x.^5).*(y.^4) (x.^4).*(y.^5)...
    (x.^3).*(y.^6) (x.^2).*(y.^7) x.*(y.^8) y.^9 x.^10 (x.^9).*y (x.^8).*(y.^2)...
    (x.^7).*(y.^3) (x.^6).*(y.^4) (x.^5).*(y.^5) (x.^4).*(y.^6) (x.^3).*(y.^7)...
    (x.^2).*(y.^8) x.*(y.^9) y.^10];
Y = dxv';
mse_dy = sum((Y-X*k1).^2)/length(x);

Y = dyv';
mse_dx = sum((Y-X*k2).^2)/length(x);

mse = mean([mse_dx mse_dy]);
end

function [mse] = poly_1111(x,y,dx,dy,xv,yv,dxv,dyv)
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3 x.^4 ...
    (x.^3).*y (x.^2).*(y.^2) x.*(y.^3) y.^4 x.^5 (x.^4).*y (x.^3).*(y.^2)...
    (x.^2).*(y.^3) x.*(y.^4) y.^5 x.^6 (x.^5).*y (x.^4).*(y.^2) (x.^3).*(y.^3)...
    (x.^2).*(y.^4) x.*(y.^5) y.^6 x.^7 (x.^6).*y (x.^5).*(y.^2) (x.^4).*(y.^3)...
    (x.^3).*(y.^4) (x.^2).*(y.^5) x.*(y.^6) y.^7 x.^8 (x.^7).*y (x.^6).*(y.^2)...
    (x.^5).*(y.^3) (x.^4).*(y.^4) (x.^3).*(y.^5) (x.^2).*(y.^6) x.*(y.^7) y.^8 ...
    x.^9 (x.^8).*y (x.^7).*(y.^2) (x.^6).*(y.^3) (x.^5).*(y.^4) (x.^4).*(y.^5)...
    (x.^3).*(y.^6) (x.^2).*(y.^7) x.*(y.^8) y.^9 x.^10 (x.^9).*y (x.^8).*(y.^2)...
    (x.^7).*(y.^3) (x.^6).*(y.^4) (x.^5).*(y.^5) (x.^4).*(y.^6) (x.^3).*(y.^7)...
    (x.^2).*(y.^8) x.*(y.^9) y.^10 x.^11 (x.^10).*y (x.^9).*(y.^2) (x.^8).*(y.^3)...
    (x.^7).*(y.^4) (x.^6).*(y.^5) (x.^5).*(y.^6) (x.^4).*(y.^7) (x.^3).*(y.^8)...
    (x.^2).*(y.^9) x.*(y.^10) y.^11];
Y = dx';
k1 = inv(X'*X)*X'*Y;
Y = dy';
k2 = inv(X'*X)*X'*Y;

x = xv;
y = yv;
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3 x.^4 ...
    (x.^3).*y (x.^2).*(y.^2) x.*(y.^3) y.^4 x.^5 (x.^4).*y (x.^3).*(y.^2)...
    (x.^2).*(y.^3) x.*(y.^4) y.^5 x.^6 (x.^5).*y (x.^4).*(y.^2) (x.^3).*(y.^3)...
    (x.^2).*(y.^4) x.*(y.^5) y.^6 x.^7 (x.^6).*y (x.^5).*(y.^2) (x.^4).*(y.^3)...
    (x.^3).*(y.^4) (x.^2).*(y.^5) x.*(y.^6) y.^7 x.^8 (x.^7).*y (x.^6).*(y.^2)...
    (x.^5).*(y.^3) (x.^4).*(y.^4) (x.^3).*(y.^5) (x.^2).*(y.^6) x.*(y.^7) y.^8 ...
    x.^9 (x.^8).*y (x.^7).*(y.^2) (x.^6).*(y.^3) (x.^5).*(y.^4) (x.^4).*(y.^5)...
    (x.^3).*(y.^6) (x.^2).*(y.^7) x.*(y.^8) y.^9 x.^10 (x.^9).*y (x.^8).*(y.^2)...
    (x.^7).*(y.^3) (x.^6).*(y.^4) (x.^5).*(y.^5) (x.^4).*(y.^6) (x.^3).*(y.^7)...
    (x.^2).*(y.^8) x.*(y.^9) y.^10 x.^11 (x.^10).*y (x.^9).*(y.^2) (x.^8).*(y.^3)...
    (x.^7).*(y.^4) (x.^6).*(y.^5) (x.^5).*(y.^6) (x.^4).*(y.^7) (x.^3).*(y.^8)...
    (x.^2).*(y.^9) x.*(y.^10) y.^11];
Y = dxv';
mse_dy = sum((Y-X*k1).^2)/length(x);

Y = dyv';
mse_dx = sum((Y-X*k2).^2)/length(x);

mse = mean([mse_dx mse_dy]);
end

function [mse] = poly_1212(x,y,dx,dy,xv,yv,dxv,dyv)
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3 x.^4 ...
    (x.^3).*y (x.^2).*(y.^2) x.*(y.^3) y.^4 x.^5 (x.^4).*y (x.^3).*(y.^2)...
    (x.^2).*(y.^3) x.*(y.^4) y.^5 x.^6 (x.^5).*y (x.^4).*(y.^2) (x.^3).*(y.^3)...
    (x.^2).*(y.^4) x.*(y.^5) y.^6 x.^7 (x.^6).*y (x.^5).*(y.^2) (x.^4).*(y.^3)...
    (x.^3).*(y.^4) (x.^2).*(y.^5) x.*(y.^6) y.^7 x.^8 (x.^7).*y (x.^6).*(y.^2)...
    (x.^5).*(y.^3) (x.^4).*(y.^4) (x.^3).*(y.^5) (x.^2).*(y.^6) x.*(y.^7) y.^8 ...
    x.^9 (x.^8).*y (x.^7).*(y.^2) (x.^6).*(y.^3) (x.^5).*(y.^4) (x.^4).*(y.^5)...
    (x.^3).*(y.^6) (x.^2).*(y.^7) x.*(y.^8) y.^9 x.^10 (x.^9).*y (x.^8).*(y.^2)...
    (x.^7).*(y.^3) (x.^6).*(y.^4) (x.^5).*(y.^5) (x.^4).*(y.^6) (x.^3).*(y.^7)...
    (x.^2).*(y.^8) x.*(y.^9) y.^10 x.^11 (x.^10).*y (x.^9).*(y.^2) (x.^8).*(y.^3)...
    (x.^7).*(y.^4) (x.^6).*(y.^5) (x.^5).*(y.^6) (x.^4).*(y.^7) (x.^3).*(y.^8)...
    (x.^2).*(y.^9) x.*(y.^10) y.^11 x.^12 (x.^11).*y (x.^10).*(y.^2) (x.^9).*(y.^3)...
    (x.^8).*(y.^4) (x.^7).*(y.^5) (x.^6).*(y.^6) (x.^5).*(y.^7) (x.^4).*(y.^8)...
    (x.^3).*(y.^9) (x.^2).*(y.^10) x.*(y.^11) y.^12];
Y = dx';
k1 = inv(X'*X)*X'*Y;
Y = dy';
k2 = inv(X'*X)*X'*Y;

x = xv;
y = yv;
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3 x.^4 ...
    (x.^3).*y (x.^2).*(y.^2) x.*(y.^3) y.^4 x.^5 (x.^4).*y (x.^3).*(y.^2)...
    (x.^2).*(y.^3) x.*(y.^4) y.^5 x.^6 (x.^5).*y (x.^4).*(y.^2) (x.^3).*(y.^3)...
    (x.^2).*(y.^4) x.*(y.^5) y.^6 x.^7 (x.^6).*y (x.^5).*(y.^2) (x.^4).*(y.^3)...
    (x.^3).*(y.^4) (x.^2).*(y.^5) x.*(y.^6) y.^7 x.^8 (x.^7).*y (x.^6).*(y.^2)...
    (x.^5).*(y.^3) (x.^4).*(y.^4) (x.^3).*(y.^5) (x.^2).*(y.^6) x.*(y.^7) y.^8 ...
    x.^9 (x.^8).*y (x.^7).*(y.^2) (x.^6).*(y.^3) (x.^5).*(y.^4) (x.^4).*(y.^5)...
    (x.^3).*(y.^6) (x.^2).*(y.^7) x.*(y.^8) y.^9 x.^10 (x.^9).*y (x.^8).*(y.^2)...
    (x.^7).*(y.^3) (x.^6).*(y.^4) (x.^5).*(y.^5) (x.^4).*(y.^6) (x.^3).*(y.^7)...
    (x.^2).*(y.^8) x.*(y.^9) y.^10 x.^11 (x.^10).*y (x.^9).*(y.^2) (x.^8).*(y.^3)...
    (x.^7).*(y.^4) (x.^6).*(y.^5) (x.^5).*(y.^6) (x.^4).*(y.^7) (x.^3).*(y.^8)...
    (x.^2).*(y.^9) x.*(y.^10) y.^11 x.^12 (x.^11).*y (x.^10).*(y.^2) (x.^9).*(y.^3)...
    (x.^8).*(y.^4) (x.^7).*(y.^5) (x.^6).*(y.^6) (x.^5).*(y.^7) (x.^4).*(y.^8)...
    (x.^3).*(y.^9) (x.^2).*(y.^10) x.*(y.^11) y.^12];
Y = dxv';
mse_dy = sum((Y-X*k1).^2)/length(x);

Y = dyv';
mse_dx = sum((Y-X*k2).^2)/length(x);

mse = mean([mse_dx mse_dy]);
end

function [mse] = poly_1313(x,y,dx,dy,xv,yv,dxv,dyv)
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3 x.^4 ...
    (x.^3).*y (x.^2).*(y.^2) x.*(y.^3) y.^4 x.^5 (x.^4).*y (x.^3).*(y.^2)...
    (x.^2).*(y.^3) x.*(y.^4) y.^5 x.^6 (x.^5).*y (x.^4).*(y.^2) (x.^3).*(y.^3)...
    (x.^2).*(y.^4) x.*(y.^5) y.^6 x.^7 (x.^6).*y (x.^5).*(y.^2) (x.^4).*(y.^3)...
    (x.^3).*(y.^4) (x.^2).*(y.^5) x.*(y.^6) y.^7 x.^8 (x.^7).*y (x.^6).*(y.^2)...
    (x.^5).*(y.^3) (x.^4).*(y.^4) (x.^3).*(y.^5) (x.^2).*(y.^6) x.*(y.^7) y.^8 ...
    x.^9 (x.^8).*y (x.^7).*(y.^2) (x.^6).*(y.^3) (x.^5).*(y.^4) (x.^4).*(y.^5)...
    (x.^3).*(y.^6) (x.^2).*(y.^7) x.*(y.^8) y.^9 x.^10 (x.^9).*y (x.^8).*(y.^2)...
    (x.^7).*(y.^3) (x.^6).*(y.^4) (x.^5).*(y.^5) (x.^4).*(y.^6) (x.^3).*(y.^7)...
    (x.^2).*(y.^8) x.*(y.^9) y.^10 x.^11 (x.^10).*y (x.^9).*(y.^2) (x.^8).*(y.^3)...
    (x.^7).*(y.^4) (x.^6).*(y.^5) (x.^5).*(y.^6) (x.^4).*(y.^7) (x.^3).*(y.^8)...
    (x.^2).*(y.^9) x.*(y.^10) y.^11 x.^12 (x.^11).*y (x.^10).*(y.^2) (x.^9).*(y.^3)...
    (x.^8).*(y.^4) (x.^7).*(y.^5) (x.^6).*(y.^6) (x.^5).*(y.^7) (x.^4).*(y.^8)...
    (x.^3).*(y.^9) (x.^2).*(y.^10) x.*(y.^11) y.^12 x.^13 (x.^12).*y (x.^11).*(y.^2)...
    (x.^10).*(y.^3) (x.^9).*(y.^4) (x.^8).*(y.^5) (x.^7).*(y.^6) (x.^6).*(y.^7)...
    (x.^5).*(y.^8) (x.^4).*(y.^9) (x.^3).*(y.^10) (x.^2).*(y.^11) x.*(y.^12) y.^13];
Y = dx';
k1 = inv(X'*X)*X'*Y;
Y = dy';
k2 = inv(X'*X)*X'*Y;

x = xv;
y = yv;
X = [ones(length(x),1) x y x.^2 x.*y y.^2 x.^3 (x.^2).*y x.*(y.^2) y.^3 x.^4 ...
    (x.^3).*y (x.^2).*(y.^2) x.*(y.^3) y.^4 x.^5 (x.^4).*y (x.^3).*(y.^2)...
    (x.^2).*(y.^3) x.*(y.^4) y.^5 x.^6 (x.^5).*y (x.^4).*(y.^2) (x.^3).*(y.^3)...
    (x.^2).*(y.^4) x.*(y.^5) y.^6 x.^7 (x.^6).*y (x.^5).*(y.^2) (x.^4).*(y.^3)...
    (x.^3).*(y.^4) (x.^2).*(y.^5) x.*(y.^6) y.^7 x.^8 (x.^7).*y (x.^6).*(y.^2)...
    (x.^5).*(y.^3) (x.^4).*(y.^4) (x.^3).*(y.^5) (x.^2).*(y.^6) x.*(y.^7) y.^8 ...
    x.^9 (x.^8).*y (x.^7).*(y.^2) (x.^6).*(y.^3) (x.^5).*(y.^4) (x.^4).*(y.^5)...
    (x.^3).*(y.^6) (x.^2).*(y.^7) x.*(y.^8) y.^9 x.^10 (x.^9).*y (x.^8).*(y.^2)...
    (x.^7).*(y.^3) (x.^6).*(y.^4) (x.^5).*(y.^5) (x.^4).*(y.^6) (x.^3).*(y.^7)...
    (x.^2).*(y.^8) x.*(y.^9) y.^10 x.^11 (x.^10).*y (x.^9).*(y.^2) (x.^8).*(y.^3)...
    (x.^7).*(y.^4) (x.^6).*(y.^5) (x.^5).*(y.^6) (x.^4).*(y.^7) (x.^3).*(y.^8)...
    (x.^2).*(y.^9) x.*(y.^10) y.^11 x.^12 (x.^11).*y (x.^10).*(y.^2) (x.^9).*(y.^3)...
    (x.^8).*(y.^4) (x.^7).*(y.^5) (x.^6).*(y.^6) (x.^5).*(y.^7) (x.^4).*(y.^8)...
    (x.^3).*(y.^9) (x.^2).*(y.^10) x.*(y.^11) y.^12 x.^13 (x.^12).*y (x.^11).*(y.^2)...
    (x.^10).*(y.^3) (x.^9).*(y.^4) (x.^8).*(y.^5) (x.^7).*(y.^6) (x.^6).*(y.^7)...
    (x.^5).*(y.^8) (x.^4).*(y.^9) (x.^3).*(y.^10) (x.^2).*(y.^11) x.*(y.^12) y.^13];
Y = dxv';
mse_dy = sum((Y-X*k1).^2)/length(x);

Y = dyv';
mse_dx = sum((Y-X*k2).^2)/length(x);

mse = mean([mse_dx mse_dy]);
end