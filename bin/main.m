function main()
%
% generates/saves all plots to plots/ dir
% where fig_ext is e.g. 'png' or 'pdf'
%
    bindir = fileparts(mfilename('fullpath'));
	cd(bindir);
    fig_ext = 'pdf';

    subj = 'ALL';
    plotAll(subj, fig_ext);
    
    subj = 'KLB';
%     plotAll(subj, fig_ext);

    close all;
end
function plotAll(subj, fig_ext)
    % surface
    dotmode = '2d';
    plotSurface;
    dotmode = '3d';
    plotSurface;

    % pmfs
    plotPsychoByCoh;
    plotPsychoByDotmode;
    plotBloch;
    
    % sat-exp curve
    plotSatExpByCoh;
    plotSatExpByDotmode;
    
    % sat-exp params
    param = 'A';
    plotSatExpParamsCoh;
    plotSatExpParams2d3d;
    param = 'T';
    plotSatExpParamsCoh;
    plotSatExpParams2d3d;
end
