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
    
    subj = 'krm';
    plotPsychoByDotmode;

    close all;
end
function plotAll(subj, fig_ext)
    % surface
    dotmode = '2d';
    plotSurface;
    plotBlochByFit;
    dotmode = '3d';
    plotSurface;
    plotBlochByFit;

    % pmfs
    plotPsychoByCoh;
    plotPsychoByDotmode;
    plotBloch;
    plotBloch_1Elb;
    
    % sat-exp curve
    plotSatExpByCoh;
    plotSatExpByDotmode;
    
    plotResid;
    
    % sat-exp params
%     param = 'A';
%     plotSatExpParamsCoh;
%     plotSatExpParams2d3d;
%     param = 'T';
%     plotSatExpParamsCoh;
%     plotSatExpParams2d3d;
end
