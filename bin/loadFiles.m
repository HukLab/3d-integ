function data = loadFiles(basename, subj)
%
% There are four allowed .csv basenames (see tempint_fmts), and each 
% basename has two .csv files associated with it: one suffixed 'params',
% the other 'pts'. This functions loads these files for both 2d and 3d, for
% a given subject.
%
    [fmt1, fmt2] = fileFormats(basename);
%     basedir = '/Users/jayhennig/Dropbox/HukLab/Temporal Integration/fits';
    basedir = '/Users/mobeets/Dropbox/Work/Huk/Temporal Integration/fits';
    if ~exist(basedir, 'dir')
        basedir = '../fits';
        disp('Using local fits instead of jayh Dropbox folder.');
    end
    fn_fcn = @(kind) [basename '-' subj '-' kind '.csv'];
    path_fcn = @(kind) fullfile(basedir, fn_fcn(kind));
    data = loadCsvs(path_fcn, fmt1, fmt2);
end

function [data] = loadCsvs(path_fcn, fmt1, fmt2)
    c1 = loadCsv(path_fcn('params'), fmt1);
    c2 = loadCsv(path_fcn('pts'), fmt2);
    data.params = c1;
    data.pts = c2;
end

function data = loadCsv(fn, fmt)
    fid = fopen(fn);
    if fid == -1
        data = [];
        return;
    end
    hdr = textscan(fgetl(fid), '%s', 'delimiter', ',');
    hdr = hdr{1};
    data = textscan(fid, fmt, 'Delimiter', ',');
    if isempty(hdr{1})
        hdr{1} = 'id';
    end
    data = cell2struct(data, hdr, 2);
end
