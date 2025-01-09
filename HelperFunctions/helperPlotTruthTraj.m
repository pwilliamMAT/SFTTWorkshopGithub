function helperPlotTruthTraj(gViewer,trajectoryCell)
% Define colors for plotting:
pColor=[1 0 0;
    0 1 0;
    0 0 1;
    0 0.5 0.5];

for i = 1:length(trajectoryCell)
    plotTrajectory(gViewer,trajectoryCell{i},Color=pColor(i,:))
end
end