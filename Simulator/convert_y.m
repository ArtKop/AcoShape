function new_positions = convert_y(positions)
new_positions = positions;
new_positions(:,2) = 1 - new_positions(:,2);
end