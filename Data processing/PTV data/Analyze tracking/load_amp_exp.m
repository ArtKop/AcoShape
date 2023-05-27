function [movement,freq,amp,duration,p_before,p_after] = load_amp_exp(beforeFile,afterFile)
	p_before = find_blobs(imread(beforeFile));  
	p_after = find_blobs(imread(afterFile));     
    m = match(p_before,p_after);
    dif = p_before(m(:,1),:) - p_after(m(:,2),:);        
    absdif = sqrt(sum(dif .^ 2,2));        
    movement = quantile(absdif,0.75);  
    info = imfinfo(beforeFile);
    str = info.Comment;
    C = textscan(str{1},'Freq: %f Amp: %f Duration: %f');
    freq = C{1};
    amp = C{2};
    duration = C{3};    
end