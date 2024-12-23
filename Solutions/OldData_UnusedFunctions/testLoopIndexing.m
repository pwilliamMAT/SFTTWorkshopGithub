
% Extract the 'time' field values
timeValues = [noisyDetections.Time];

%% Run simulation loop

% Run tracker on loaded detection data
count=0;
restart(scene)
reset(tracker)

% Run Simulation Loop
while advance(scene)
    count = count+1;
    time = scene.SimulationTime;

    % Find indices where the 'time' field matches the target value
    deltaTimeCheck = timeValues - time;
    matchingIndices = abs(deltaTimeCheck)<0.1;
    %disp('tot')
    if sum(matchingIndices) ~= 4
        noisyDetections(matchingIndices).Time
    end
    %disp('timeVals')
    %noisyDetections(matchingIndices).Time

    % % Pass just trajectories:
    % trackCount = [count count+101 count+202 count+303];
    % [tracks,~,~,info] = tracker(noisyDetections(trackCount),time);
    % 
    % % Generate truths using simulation
    % truths = helperGetTruths(trajectoryCell,time);
    % 
    % % Plot Detection
    % plotDetection(gViewer,noisyDetections(trackCount),"ECEF");
    % 
    % % Pause so you can visualize detections as they are plotted
    pause(0.1)
    % 
    % % Plot Tracks
    % plotTrack(gViewer,tracks,"ECEF");
end