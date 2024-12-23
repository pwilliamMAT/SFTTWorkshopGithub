function mahCorrTruth = helperRunDataLoop(detectionPosition,truthPosition,filter,time,detectionMeasurementNoise)

tp = theaterPlot();

% Create Plotters
trajPlotter = trajectoryPlotter(tp,'DisplayName','Truth Data','LineWidth',1,'LineStyle','-','Color','k');
%detPlotter = detectionPlotter(tp,'HistoryDepth',1e3,'DisplayName','Detection','MarkerSize',10,'MarkerFaceColor','r');
detPlotter = trackPlotter(tp,'HistoryDepth',1e3,'DisplayName','Detection','MarkerSize',10,'MarkerFaceColor','r','MarkerEdgeColor','r','ConnectHistory','on');
predPlotter = trackPlotter(tp,'HistoryDepth',1e3,'DisplayName','Prediction','MarkerSize',10,'MarkerFaceColor','b','MarkerEdgeColor','b','ConnectHistory','on');
corrPlotter = trackPlotter(tp,'HistoryDepth',1e3,'DisplayName','Correction','MarkerSize',10,'MarkerFaceColor','g','MarkerEdgeColor','g','ConnectHistory','on');

% Plot Truth As Trajectory
plotTrajectory(trajPlotter,{truthPosition'})
grid on, box on; legend(gca,'Location','northwest')

% Extend Measurement noise:
measurementNoise3D = repmat(detectionMeasurementNoise,[1,1,height(detectionPosition')]);

% Plot Detections in a "as sensor detects target" fashion
deltaT = diff(time);
deltaT = deltaT(1);
for n = 1:length(time)
    % Plot Position of Current Detection iteration 
    % plotDetection(detPlotter,detectionPosition',measurementNoise3D) % Adds ellipses on Detections
    plotTrack(detPlotter,detectionPosition(:,n)',string(1))

    % Make state prediction using predict method of the filter
    [pstates(n,:), pCov(:,:,n)]  = predict(filter,deltaT);

    % Correct estimate using detections and the correct method of the filter
    [cstates(n,:), cCov(:,:,n)] = correct(filter, detectionPosition(:,n)');
    
    % Pause during loop to watch tracker progress during visualization
    pause(0.1)
end

% Pull out position only from prediction and correction, for plotting
% Constant Velocity
% pstatesPos = pstates(:,[1 3 5]);
% cstatesPos = cstates(:,[1 3 5]);

% Constant Turn
% pstatesPos = pstates(:,[1 3 6]);
% cstatesPos = cstates(:,[1 3 6]);

% Constant Acceleration
% The state of the filter is defined as [x; vx; ax; y; vy; ay; z; vz; az], in which x, y, z are the position coordinates, vx, vy, vz are the corresponding velocities, and ax, ay, az are the corresponding accelerations.
pstatesPos = pstates(:,[1 4 7]); pstatesVelo = pstates(:,[2 5 8]); posPCov = pCov([1 4 7],[1 4 7],:);
cstatesPos = cstates(:,[1 4 7]); cstatesVelo = cstates(:,[2 5 8]); posCCov = cCov([1 4 7],[1 4 7],:);

% Plot Prediction and Correction, then add Title and Rotate to 2D view
for j = 1:size(pstatesPos,1)1 4 7
    plotTrack(predPlotter,pstatesPos(j,:),posPCov(:,:,j),string(1)) % Plot Prediction
    plotTrack(corrPlotter,cstatesPos(j,:),posCCov(:,:,j),string(1)) % Plot Correction

    % Pause during loop to watch tracker progress during visualization
    pause(0.1)
end
title('Filter Progress'); hold on; grid on; axis equal; % Add Title
view([0 90.00]) % Rotate to 2D view

% Calculate Mahalanobis Distance - Position-Only (posnees) form:
% Corrected versus Truth
mahCorrTruth = helperCalcMahalanobisDist(truthPosition,cstates,cCov,time);

end