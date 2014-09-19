function [fmt1, fmt2] = fileFormats(basename)
%
% The row formats for the four types of csv files,
% as written by fig_data_gen.sh (see bitbucket repo)
% 
% n.b. %f is float, %s is string 
% fmt1 is params, fmt2 is pts
%
    if strcmp('pcorVsCohByDur_thresh', basename) || strcmp('pcorVsCohByDur_thresh_by_dotmode', basename)
        fmt1 = '%f%s%s%f%f%f%f%f%f%f%f';
        fmt2 = '%f%s%s%f%f%f%f%f';
    elseif strcmp('pcorVsCohByDur_elbow', basename)
        fmt1 = '%f%f%f%f%f%s%f%f%f%f%f%s';
        fmt2 = '';
    elseif strcmp('pcorVsDurByCoh', basename)
        fmt1 = '%f%f%f%f%s%s';
        fmt2 = '%f%s%f%f%f%s%s';
    elseif strcmp('fitCurveVsDurByCoh', basename)
        fmt1 = '%f%f%f%f%f%f%s%s';
        fmt2 = '%f%f%f%s%f%f%f%f%s';
    elseif strcmp('pcor', basename)
        fmt1 = '';
        fmt2 = '%f%f%f%f%s';
    else
        error('invalid filetype.');
    end
end
