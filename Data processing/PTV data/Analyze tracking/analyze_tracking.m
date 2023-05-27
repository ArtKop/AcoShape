clear
close all
%%
id = 'solderball_20200520_amptest'; % Identifier of the experiment run
discard_threshold = 0.0035 * 20;
prefiximg = 'Tracktest_2020_5\';
datafile = [prefiximg id '.mat'];
load(datafile);

%%
alldata = cell(1,length(exps));

freq = modeInfo.freq;
duration = modeInfo.duration;
amp = modeInfo.amp;
exps = exps;

N = length(exps);
parfor i = 1:N
    beforefile = sprintf('%s%s_%06d_%.0f_%.0f_%.3f_in.jpg',prefiximg,id,i,freq(exps(i)),duration(exps(i)),amp(exps(i)));       
    afterfile = sprintf('%s%s_%06d_%.0f_%.0f_%.3f_out.jpg',prefiximg,id,i,freq(exps(i)),duration(exps(i)),amp(exps(i)));
    if exist(beforefile,'file') && exist(afterfile,'file')
        [~,~,~,~,p_before,p_after] = load_amp_exp(beforefile,afterfile);
        m = optimal_match(p_before,p_after,discard_threshold);              
        p = p_before(m(:,1),:);
        v = p_after(m(:,2),:) - p;
        alldata{i} = [p v];
    end
    fprintf('%d / %d (%%%.2f done)\n',i,N,i/N*100);
end   

data = cell(1,length(freq));
for i = 1:N
    data{exps(i)} = [data{exps(i)};alldata{i}];
end