function ret = getTrackingDataPath()
    filepath = mfilename('fullpath');
    subpath = fileparts(filepath);
    mainpath = fileparts(subpath);
    ret = [mainpath '\TrackingData\'];
end