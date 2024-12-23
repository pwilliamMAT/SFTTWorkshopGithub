function tracker = helperChooseTracker(trackerChoice,noisyDetections)

if strcmp(trackerChoice,"GNN")
    knownVelo = 7.5e3;
    tracker = trackerGNN('FilterInitializationFcn',@(detection)helperInitFilter(detection,knownVelo),AssignmentThreshold=175);

elseif strcmp(trackerChoice,"JPDA")
    knownVelo = 7.5e3;
    tracker = trackerJPDA('FilterInitializationFcn',@(detection)helperInitFilter(detection,knownVelo),...
        AssignmentThreshold=175, ...
        TrackLogic = 'Integrated',...
        ConfirmationThreshold=0.9, ...
        ClutterDensity = 1e-20);

elseif strcmp(trackerChoice,"TOMHT")    
    knownVelo = 1e4; % Increase slightly from known velocity
    tracker = trackerTOMHT('FilterInitializationFcn',@(detection)helperInitFilter(detection,knownVelo),...
        AssignmentThreshold=175*[0.3 0.7 1 Inf],... % Reminder: "val" is a gate parameter
        Beta=1e-45,...
        Volume= det(noisyDetections(1).MeasurementNoise)/1e3,... % Use a volume relative to that defined by the Measurement Noise
        FalseAlarmRate=1e-20);
else
    disp('error')
end

end