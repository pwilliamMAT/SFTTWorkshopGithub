function [labels,tp] = helperCreateScenario(truthPosition,tp,f)
% Plot noisy and truth trajectory data
%clf
%f=figure;
f.Position = [1e3 818 560*2 420*2];
truePos = plot3(truthPosition(1,:),truthPosition(2,:),truthPosition(3,:)); hold on;

% Plot radar sensor location:
pos_radar = plot3(0,0,0);
pos_radar.Marker = 'o';
pos_radar.MarkerSize = 10;
pos_radar.MarkerFaceColor = 'g';
pos_radar.LineStyle = 'none';
legend([truePos,pos_radar],'True Location','Radar Sensor (Assumed)')
title('Track Constant Velocity Target')
grid on 
box on
axis vis3d equal
xlabel('X')
ylabel('Y')
zlabel('Z')
view(17,41)

% % Setup Viewer and Plotters:
% %tp = theaterPlot('Parent',gca);
% minVals = min(truthPosition');
% maxVals = max(truthPosition');
% % tp.XLimits = [-2.7776e+04 1.5037e+04];
% % tp.YLimits = [-1.3634e+04 2.9844e+04];
% % tp.ZLimits = [0 6.7006e+03];
% 
% % Adjust limits to show track
% %minVals = minVals - abs(minVals*0.5);
% %maxVals = maxVals + abs(maxVals*0.5); % Goal: xlim([-2979958 97,000])
% 
% tp.XLimits = [minVals(1) maxVals(1)];
% tp.YLimits = [minVals(2) maxVals(2)];
% tp.ZLimits = [minVals(3) maxVals(3)];

tp.XLimits =[-3052169 186107];
tp.YLimits = [-6064921 -4800871];
tp.ZLimits = [1972664 4943478];
view([9 26])

labels = {'Current Radar Detection'};
end