function [fmt1, fmt2] = fileFormats(basename)
%
% The row formats for the four types of csv files,
% as written by fig_data_gen.sh (see bitbucket repo)
% 
% n.b. %f is float, %s is string 
% fmt1 is params, fmt2 is pts
%
    if strcmp('pcorVsCohByDur_thresh', basename)
        fmt1 = '%f%s%s%f%f%f%f%f%f%f%f';
        fmt2 = '%f%s%s%f%f%f%f%f';
    elseif strcmp('pcorVsCohByDotmode_thresh', basename)
        fmt1 = '%f%s%s%f%f%f%f%f%f%f%f';
        fmt2 = '%f%s%s%f%f%f%f%f';
    elseif strcmp('pcorVsCohByDur_elbow', basename)
        fmt1 = '%f%f%f%f%f%s%f%f%f%f%f%s';
        fmt2 = '';
    elseif strcmp('pcorVsCohByDur_0elbow', basename)
        fmt1 = '%f%f%f%s%f%s';
        fmt2 = '';
    elseif strcmp('pcorVsCohByDur_1elbow', basename)
        fmt1 = '%f%f%f%f%s%f%f%f%s';
        fmt2 = '';
    elseif strcmp('pcorVsDurByDotmode', basename)
        fmt1 = '%f%f%f%f%f%s%s';
        fmt2 = '%f%f%s%f%f%f%s%s';
    elseif strcmp('pcorVsDurByCoh', basename)
        fmt1 = '%f%f%f%f%f%s%f%s';
        fmt2 = '%f%f%s%f%f%f%s%f%s';
    elseif strcmp('pcor', basename)
        fmt1 = '';
        fmt2 = '%f%f%f%f%s';
    elseif strcmp('sensVsDurSlopes', basename)
        fmt1 = '%f%s%s%f%f%f%f';
%         fmt1 = '%f%s%s%f%f%f%f%f%f%f%f%f';
        fmt2 = '';
    else
        error('invalid filetype.');
    end
end
