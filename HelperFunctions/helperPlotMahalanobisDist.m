function [d2, figHandle]= helperPlotMahalanobisDist(d2,prevD2)

% Instead, plot them as subplots next to one another
figHandle = figure; subplot(1,2,1); hold on; plot(prevD2,'LineWidth',2,'Color','k','LineStyle','--');
ybars = [0 2.5];
ybarsBad = [2.5 max(ylim)];
minX  = min(xlim); maxX = max(xlim);
cla;

patch([minX maxX maxX minX], [ybars(1) ybars(1), ybars(2) ybars(2)], [0.1 0.8 0.1]) % Green, good
patch([minX maxX maxX minX], [ybarsBad(1) ybarsBad(1), ybarsBad(2) ybarsBad(2)], [0.8 0.4 0.4]) % Red, bad

% Repeated plot call to prevent patch from hiding
plot(prevD2,'LineWidth',2,'Color','k','LineStyle','--');
xlabel('Samples')
ylabel('Mahalanobis Distance')
title(sprintf('Compare Corrected to Truth\n - Previous'))

% Create Legend
legend({'Acceptable Distance','Distance Too Large','Previous Mahalanobis Dist',})

% SECOND SUBPLOT
subplot(1,2,2); hold on; plot(d2,'LineWidth',2,'Color','b');
minX  = min(xlim); maxX = max(xlim);
ybarsBad = [2.5 max(ylim)];
cla;

patch([minX maxX maxX minX], [ybars(1) ybars(1), ybars(2) ybars(2)], [0.1 0.8 0.1]) % Green, good
patch([minX maxX maxX minX], [ybarsBad(1) ybarsBad(1), ybarsBad(2) ybarsBad(2)], [0.8 0.4 0.4]) % Red, bad

% Repeated plot call to prevent patch from hiding
plot(d2,'LineWidth',2,'Color','b');
xlabel('Samples')
ylabel('Mahalanobis Distance')
title(sprintf('Compare Corrected to Truth\n - Current'))

% Create Legend
legend({'Acceptable Distance','Distance Too Large','Current Mahalanobis Dist',})

end