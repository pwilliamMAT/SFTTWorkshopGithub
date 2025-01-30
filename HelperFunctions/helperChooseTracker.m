function tracker = helperChooseTracker(trackerChoice)

if strcmp(trackerChoice,"GNN")
    knownVelo = 7.5e3;
    tracker = trackerGNN('FilterInitializationFcn',@(detection)helperInitFilter(detection,knownVelo),...
        AssignmentThreshold=175);

elseif strcmp(trackerChoice,"JPDA")
    knownVelo = 7.5e3;
    tracker = trackerJPDA('FilterInitializationFcn',@(detection)helperInitFilter(detection,knownVelo),...
        AssignmentThreshold=175, ...
        TrackLogic = 'Integrated',...
        ConfirmationThreshold=0.9, ...
        ClutterDensity = 1e-20);
else
    disp('error')
end

end