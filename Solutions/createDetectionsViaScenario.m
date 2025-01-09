% Add Targets from workshop 
S = load('SpaceDebrisLEO_4Targets.mat');
UpdateRate=S.UpdateRate;
noisyDetections=S.noisyDets;
stopTime=S.stopTime;
time=S.time;
trajectoryCell=S.trajectoryCell;

% Borrow sensor construction from doc example
% First station coordinates in LLA
station1 = [48 -80 0] - [20 20 0];

% Each station is equipped with a radar, which is modeled by using a fusionRadarSensor object. In order to detect satellites in the LEO range, the radar has the following requirements:
% Detecting a 5 dBsm object up to 5,000 km away
% Resolving objects horizontally and vertically with a precision of 10Deg at 20,000 km range
% Having a field of view of 120 degrees in azimuth and 30 degrees in elevation
% Looking up into space

% Create fan-shaped monostatic radar - make super wide to encapsulate all
% target locations
fov = [360;180]; % Make it unusually wide
radar1 = fusionRadarSensor(1,...
    'UpdateRate',0.2879,... 10 sec
    'ScanMode','No scanning',...
    'MountingAngles',[0 90 0],... look up
    'FieldOfView',fov,... degrees
    'ReferenceRange',2000e4,... m
    'RangeLimits',  [0 5e6], ... m -2000e3 - Make it crazy big
    'ReferenceRCS', 5,... dBsm
    'HasFalseAlarms',false,...
    'HasNoise', true,...
    'HasElevation',true,...
    'AzimuthResolution',10,... degrees
    'ElevationResolution',10,... degrees
    'RangeResolution',1e6, ... m % accuracy ~= 2000 * 0.05 (m)
    'DetectionCoordinates','Scenario',...
    'HasINS',true,...
    'TargetReportFormat','Detections');

%% Create Scene and Viewer
scene = trackingScenario('IsEarthCentered',true,'UpdateRate',0);
gViewer = trackingGlobeViewer('ShowDroppedTracks',false, 'PlatformHistoryDepth',700);

ned1 = dcmecef2ned(station1(1),station1(2));
covcon(1) = coverageConfig(radar1,lla2ecef(station1),quaternion(ned1,'rotmat','frame'));
plotCoverage(gViewer, covcon, 'ECEF');

%% Configure Satellite Targets
% Create Satellites with dimensions 3 x 3 x 1 (m)
sat(1) = platform(scene);
sat(1).Dimensions = struct('Length',3,'Width',3,'Height',1,'OriginOffset',[0 0 0]);
sat(1).Trajectory = trajectoryCell{1};

sat(2) = platform(scene);
sat(2).Dimensions = struct('Length',3,'Width',3,'Height',1,'OriginOffset',[0 0 0]);
sat(2).Trajectory = trajectoryCell{2};

sat(3) = platform(scene);
sat(3).Dimensions = struct('Length',3,'Width',3,'Height',1,'OriginOffset',[0 0 0]);
sat(3).Trajectory = trajectoryCell{3};

sat(4) = platform(scene);
sat(4).Dimensions = struct('Length',3,'Width',3,'Height',1,'OriginOffset',[0 0 0]);
sat(4).Trajectory = trajectoryCell{4};

% Add Platform for Radar Sensor
plat = platform(scene,'Position',station1);
plat.Dimensions = struct('Length',3,'Width',3,'Height',1,'OriginOffset',[0 0 0]);
plat.Sensors = radar1;

% Visualize Trajectory
satRoute1 = trajectoryCell{1};
satRoute2 = trajectoryCell{2};
satRoute3 = trajectoryCell{3};
satRoute4 = trajectoryCell{4};

plotTrajectory(gViewer,satRoute1);
plotTrajectory(gViewer,satRoute2);
plotTrajectory(gViewer,satRoute3);
plotTrajectory(gViewer,satRoute4);

%% Update Scene
restart(scene)
detBuffer = {}; dets1=[];dets2=[];
count = 0;

% Run Simulation Loop
while advance(scene)
    
    % Update position of satellites
    poses = platformPoses(scene);
    plotPlatform(gViewer,sat);

    % Generate and plot synthetic radar detections
    [dets1, configs] = detect(scene);
    %[dets2,numDets,config] = radar1(scene.platformPoses,scene.SimulationTime);
    detBuffer = [detBuffer; dets1]; %#ok<AGROW>
    plotDetection(gViewer,detBuffer,'ECEF');

    % Pause so you can visualize detections as they are plotted
    %pause(0.1)

    %detBuffer = {};
end