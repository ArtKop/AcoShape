function ret = simulatedPlate(p,maps)        
    % simulatedPlate  Constructor for creating a mockup plate object
    %
    %                 plate = simulatedPlate(p,maps) creates a simulated plate
    %                   using the maps struct array and p starting point
    
    ret = struct('play',@play,'getPositions',@getPositions,'setTarget',@setTarget);                       
    
    % In real plate, this will play real sound
    % The mockup plate simulates the movement based on deltaX and deltaY,
    % adding some randonmness based on the variance maps
    function play(frequencyId)                      
        if (frequencyId < 1 || frequencyId > length(maps))
            error('Invalid frequencyId, should be between 1..%d (was: %d)',length(maps),frequencyId);
        end                
        noise = (sqrt(max(maps(frequencyId).variance(p),0)) * [1 1]) .* randn(size(p));
        
%           noise = (sqrt(max(maps(frequencyId).STD(ceil(p*21)),0))) .* randn(size(p));
%           p = p + [maps(frequencyId).gU(ceil(p(:,1)*21)),maps(frequencyId).gV(ceil(p(:,2)*21))] + noise;
        p = p + [maps(frequencyId).deltaX(p),maps(frequencyId).deltaY(p)] + noise;        
        pause(1e-6); % slow things down just enough matlab has time to plot things
    end

    % In real plate, this will perform machine vision
    function ret = getPositions()
        ret = p;
    end
end