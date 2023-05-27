function new_tarPos = traslate_back(tarPos,pic_size,margin)
% translate the pattern to the acceptable area within
% the plate + margin distance from the plates's edge

up_x = max(tarPos(:,1)); down_x = min(tarPos(:,1));
up_y = max(tarPos(:,2)); down_y = min(tarPos(:,2));

if pic_size < up_x
    tr_x = pic_size - up_x - margin;
elseif down_x < 0
    tr_x = - down_x - margin;
else
    tr_x = 0;
end
if pic_size < up_y
    tr_y = pic_size - up_y - margin;
elseif down_y < 0
    tr_y = - down_y - margin;
else
    tr_y = 0;
end

new_tarPos = tarPos + [tr_x tr_y];
end