function [d2]= helperPlotMahalanobisDist_FirstPlot(d2)

% Plot only current Mahalanobis Distance
ybars = [0 2.5];

% SECOND SUBPLOT
figure; hold on; plot(d2,'LineWidth',2,'Color','b');
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
legend({'Acceptable Distance','Distance Too Large','Current Mahalanobis Dist'},"Location","northwest")

end
