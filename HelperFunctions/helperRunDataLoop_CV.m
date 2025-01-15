function mahCorrTruth = helperRunDataLoop_CV(detectionPosition,truthPosition,filter,time,detectionMeasurementNoise)

tp = theaterPlot();

% Create Plotters
trajPlotter = trajectoryPlotter(tp,'DisplayName','Truth Data','LineWidth',1,'LineStyle','-','Color','k');
detPlotter = detectionPlotter(tp,'HistoryDepth',1e3,'DisplayName','Detection','MarkerSize',10,'MarkerFaceColor','r');
predPlotter = trackPlotter(tp,'HistoryDepth',1e3,'DisplayName','Prediction','MarkerSize',10,'MarkerFaceColor','b','MarkerEdgeColor','b','ConnectHistory','on');
corrPlotter = trackPlotter(tp,'HistoryDepth',1e3,'DisplayName','Correction','MarkerSize',10,'MarkerFaceColor','g','MarkerEdgeColor','g','ConnectHistory','on');

% Plot Truth As Trajectory
plotTrajectory(trajPlotter,{truthPosition'})
grid on, box on; legend(gca,'Location','northwest')

% Plot Detections in a "as sensor detects target" fashion
deltaT = diff(time);
deltaT = deltaT(1);
for n = 1:length(time)
    % Plot Position of Current Detection iteration 
    plotDetection(detPlotter,detectionPosition(:,n)',detectionMeasurementNoise) % Adds ellipses on Detections

    % Make state prediction using predict method of the filter
    [pstates(n,:), pCov(:,:,n)]  = predict(filter,deltaT);

    % Correct estimate using detections and the correct method of the filter
    [cstates(n,:), cCov(:,:,n)] = correct(filter, detectionPosition(:,n)');
    
    % Pull out position only from prediction and correction, for plotting
    % Constant Velocity
    pstatesPos = pstates(:,[1 3 5]); posPCov = pCov([1 3 5],[1 3 5],:);
    cstatesPos = cstates(:,[1 3 5]); posCCov = cCov([1 3 5],[1 3 5],:);

    % Plot Prediction and Correction
    plotTrack(predPlotter,pstatesPos(n,:),posPCov(:,:,n),string(1)) % Plot Prediction
    plotTrack(corrPlotter,cstatesPos(n,:),posCCov(:,:,n),string(1)) % Plot Correction

    % Draw Detections and Tracks During Each Loop
    drawnow
end

% Add Title and Rotate to 2D view
title('Filter Progress'); hold on; grid on; axis equal; % Add Title
view([0 90.00]) % Rotate to 2D view

% Calculate Mahalanobis Distance - Position-Only (posnees) form:
% Corrected versus Truth
mahCorrTruth = helperCalcMahalanobisDist_CV(truthPosition,cstates,cCov,time);

end