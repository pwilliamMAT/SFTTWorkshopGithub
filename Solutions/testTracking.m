%Build trackingGlobeViewer scenario
h = uifigure;
%Configure Tracker.  Switching between different tracker types reruns the section.
trackerChoice = "JPDA";
tracker = helperChooseTracker(trackerChoice);
%Establish map origin and create trackingGlobeViewer object.
mapOrigin = [42.39423231362 -70.95934958874 0];

%Coding Directions:
%Create a trackingGlobeViewer for the tracker to be tested in and store that in the variable "gViewer". Use the "trackingGlobeViewer" function and pass the figure handle and reference location to the function. The figure handle is stored in the variable "h" and the reference location for the viewer is stored in the variable "mapOrigin".
%(Hint: you will need to use the "ReferenceLocation" name-value pair to configure the settings of the trackingGlobeViewer)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WRITE YOUR CODE HERE:
% type "doc trackingGlobeViewer" in the Command Window to find the documentation page for this function
gViewer = trackingGlobeViewer(h,'ReferenceLocation',mapOrigin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Adjust the camera to view the area of interest:
campos(gViewer,[37.2337 -91.6920 5.5488e+06]);
%Plot truthTrajectory for reference:
helperPlotTruthTraj(gViewer,trajectoryCell)
%Run simulation loop
reset(tracker)
detectionTimeValues = [noisyDetections.Time];
[uniqueDetectionTimeValues,~,detectionIdx] = unique(detectionTimeValues);
%Run Simulation Loop
for i = 1:length(uniqueDetectionTimeValues)
    
    % Extract the data for the current timepoint
    currentDetections = noisyDetections(detectionIdx == i);

    % Create Tracks
    [tracks,~,~,info] = tracker(currentDetections,uniqueDetectionTimeValues(i));

    % Plot Detection
    plotDetection(gViewer,currentDetections,"ECEF");

    % Plot Tracks
    plotTrack(gViewer,tracks,"ECEF"); 

    % Draw Detections During Each Loop
    drawnow
end