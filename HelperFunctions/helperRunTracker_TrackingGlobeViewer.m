function [trackSummary, truthSummary, trackMetrics, truthMetrics, time] = helperRunTracker_TrackingGlobeViewer(dataLog,tracker,showTruth)
%helperRunTracker  Run the tracker and collect track metrics
% [trackSummary, truthSummary, trackMetrics, truthMetrics, time] =
% helperRunTracker(dataLog,tracker,showTruth) runs the tracker on the
% detections logged in dataLog.
%
% tracker must be either a trackerGNN, a trackerJPDA or a trackerTOMHT object.
% showTruth is a logical flag. If set to true, the display will show the
% ground truth of the targets at the end of the run.

%   Copyright 2018-2019 The MathWorks, Inc.

validateattributes(tracker,{'trackerGNN','trackerTOMHT','trackerJPDA','numeric'},{},mfilename,'tracker');

%% Create Display
% Create a display to show the true, measured, and tracked positions of the
% airliners.

% trackingGlobeViewer
scenario = trackingScenario;
origin = [42.366978, -71.022362, 50];
mapViewer = trackingGlobeViewer('ReferenceLocation',origin,...
    'Basemap','streets-dark');
cameraPos = [42.3710   -71.2533  7.8015e+03];
campos(mapViewer,cameraPos(1),cameraPos(2),cameraPos(3));
   
drawnow;
plotScenario(mapViewer,scenario);
snapshot(mapViewer);

if showTruth
    p1Traj = waypointTrajectory(vertcat(dataLog.Truth(1,:).Position),dataLog.Time);
    p2Traj = waypointTrajectory(vertcat(dataLog.Truth(2,:).Position),dataLog.Time);
    p1 = platform(scenario,'Trajectory',p1Traj);
    p2 = platform(scenario,'Trajectory',p2Traj);
    plotPlatform(mapViewer, p1, 'TrajectoryMode','Full');
    plotPlatform(mapViewer, p2, 'TrajectoryMode','Full');
end

%% Track Metrics
% Use the trackAssignmentMetrics and the trackErrorMetrics to capture
% assignment and tracking error values.
tam = trackAssignmentMetrics('AssignmentThreshold', 3, 'DivergenceThreshold', 5);
tem = trackErrorMetrics;

%% Run the tracker
time = 0;
numSteps = numel(dataLog.Time);
i = 0;
while i < numSteps %&& ishghandle(hfig)
    i = i + 1;
    
    % Current simulation time
    simTime = dataLog.Time(i);
    
    scanBuffer = dataLog.Detections{i};
    
    % Update tracker
    tic
    tracks = tracker(scanBuffer,simTime);
    time = time+toc;
    
    % Target poses in the radar's coordinate frame
    targets = dataLog.Truth(:,i);
    
    % Update track assignment metrics
    step(tam, tracks, targets);
    
    % Update track error metrics
    [trackIDs,truthIDs] = currentAssignment(tam);
    tem(tracks,trackIDs,targets,truthIDs);
    
    % Update display with current beam position, buffered detections, and
    % track positions
    allDets = [scanBuffer{:}];
    plotDetection(mapViewer,allDets);
    
    plotTrack(mapViewer,tracks, 'LabelStyle','ATC');
       
    drawnow
end

trackSummary = trackMetricsTable(tam);
truthSummary = truthMetricsTable(tam);
trackMetrics = cumulativeTrackMetrics(tem);
truthMetrics = cumulativeTruthMetrics(tem);
trVarsToRemove = {'DivergenceCount','DeletionStatus','DeletionLength','DivergenceLength','RedundancyStatus','RedundancyCount'...
    ,'RedundancyLength','FalseTrackLength','FalseTrackStatus','SwapCount'};
trackSummary = removevars(trackSummary,trVarsToRemove);
tuVarsToRemove = {'DeletionStatus','BreakStatus','BreakLength','InCoverageArea','EstablishmentStatus'};
truthSummary = removevars(truthSummary,tuVarsToRemove);
end