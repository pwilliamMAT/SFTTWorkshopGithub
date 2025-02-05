function tracker = helperChooseTracker_Ex3Bonus(trackerChoice)

if strcmp(trackerChoice,"GNN")
    knownVelo = 7.5e3;
    tracker = trackerGNN('FilterInitializationFcn',@(detection)helperInitFilter(detection,knownVelo),...
        AssignmentThreshold=75,...
        ConfirmationThreshold=[3,5]); % lower this for clutter

elseif strcmp(trackerChoice,"JPDA")
    knownVelo = 7.5e3;
    tracker = trackerJPDA('FilterInitializationFcn',@(detection)helperInitFilter(detection,knownVelo),...
        AssignmentThreshold=25, ...
        TrackLogic = 'Integrated',... % This makes it JIPDA
        ConfirmationThreshold=0.9, ...
        ClutterDensity = 1e-20,...
        NewTargetDensity=1e-17); % less likely that detection is New Target as compared to Clutter
else
    disp('error')
end

end


% % Calculate average volume in cartesian
% Rm = 5e6/2; % Use half range as average 
% dR = 1e4;
% dTheta = 10;
% dPhi = 10;
% VCell = 2*((Rm+dR)^3 - Rm^3)/3*(sind(dTheta/2))*deg2rad(dPhi);
% 
% % False alarm rate
% Pfa = radar1.FalseAlarmRate;
% 
% a = [360 180 5e6]./[10 10 1e4]; % from radar definition
% clutter_per_timestep = prod(a)*Pfa;
% 
% ClutterDensity = Pfa/VCell; % 5.2382e-20
