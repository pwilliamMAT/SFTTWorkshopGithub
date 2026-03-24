%[text] # Exercise 4: Leverage `trackerTOMHT` for Closely Spaced Targets
%[text] ## Exercise 4: Test MHT Tracker on Closely Spaced Targets Under Ambiguity
%[text] Now that we've established that our tracker and filter combination works well with the single representative target, let's leverage an MHT Tracker to evaluate its suitability to the data association challenge with a new scenario, namely the closely spaced targets under ambiguity scenario from this [documentation example](https://www.mathworks.com/help/fusion/ug/tracking-closely-spaced-targets-under-ambiguity.html?s_tid=srchtitle_support_results_2_tracking+closely).
load ATCdata.mat
helperPlotScenarioAndDetections(dataLog);
%[text] The sensor bin volume can be roughly estimated using the determinant of a detection measurement noise. In this case, the value is about 1e9, so you set the volume to 1e9. The value of beta should specify how many new objects are expected in a unit volume. As the number of objects in this scenario is constant, set beta to be very small. The values for probability of detection and false alarm rate are taken from the corresponding values of the radar.
numTracks = 20; % Maximum number of tracks
gate = 45;      % Association gate - Adjust gate for Step 3
vol = 1e9;      % Sensor bin volume
beta = 1e-14;   % Rate of new targets in a unit volume
pd = 0.8;       % Probability of detection
far = 1e-6;     % False alarm rate
%%
%[text] <u>Coding Directions:</u>
%[text] **Step 1: Instantiate a constant velocity filter within trackerTOMHT.** This is accomplished by passing the "initCVFilter" function as an anonymous function (i.e. @Func) to the 'FilterInitializationFcn' parameter of the "trackerTOMHT" function. **Then run section to see results.**
%[text] **BONUS** - Type "open initCVFilter" in the command window to open the filter function and inspect parameters chosen for this tracking scenario.
%[text] **Step 2: Change the filter initialization to leverage an IMM filter within trackerTOMHT.** Add the interacting multiple model (IMM) filter initialization to the instantiation of the MHT tracker. 
%[text] This is accomplished by passing the "initIMMFilter" function as an anonymous function (i.e. @Func) to the 'FilterInitializationFcn' parameter of the "trackerTOMHT" function. **Then run section to see results.**
%[text] **BONUS** - Type "open initIMMFilter" in the command window to open the filter function and inspect parameters chosen for this tracking scenario.
%[text] **Step 3:** **Change the distance method used within trackerTOMHT**. Leverage the "initIMMFilterCustom" function as an anonymous function (i.e. @Func) to the 'FilterInitializationFcn' parameter of the "trackerTOMHT" function. **Then run section to see results.**
%[text] - Consider changing the **gate to 9** in the above section.
%[text] - Consider changing the AssignmentThreshold to **\[0.08, 0.4 1.25\]\*gate** \
%[text] **BONUS** - Type "open trackingEKFCustom" and/ or "open initIMMFilterCustom" in the command window to open the code used to change the distance function leveraged by the tracker.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WRITE YOUR CODE HERE:
% type "doc trackerTOMHT" in the Command Window to find the documentation page for this function
tracker = trackerTOMHT( ...
    'FilterInitializationFcn',%codeHere%, ...  % Code Needed Here
    'MaxNumTracks', numTracks, ...
    'MaxNumSensors', 1, ...
    'AssignmentThreshold', [0.2, 1, 1]*gate,...
    'DetectionProbability', pd, 'FalseAlarmRate', far, ...
    'Volume', vol, 'Beta', beta, ...
    'MaxNumHistoryScans', 10,...
    'MaxNumTrackBranches', 5,...
    'NScanPruning', 'Hypothesis', ...
    'OutputRepresentation', 'Tracks');
%[text] Run Tracker and Plot
[trackSummary, truthSummary, trackMetrics, truthMetrics, timeTOMHTCV] = helperRunTracker_TrackingGlobeViewer(dataLog,tracker,true);
%[text] **In the CV Filter case (Step 1),** the results show the multiple-hypothesis tracker is capable of tracking the two truth objects throughout the scenario. For the ambiguity region, the MHT tracker formulates two hypotheses about the assignment: 
%[text] - The detection is assigned to track 1. 
%[text] - The detection is assigned to track 2.  \
%[text] With these hypotheses, both tracks generate branches (track hypotheses) that update them using the same detection. Obviously, using the same detection to update both tracks causes the tracks to become closer in their estimate, and eventually the two tracks may coalesce. However, if the duration of the ambiguous assignment is short, the tracker may be able to resolve the two tracks when there are two detections. 
%[text] You see that the two tracks cross each other, but the metrics show that the break count for each truth is 1, meaning that the true targets probably did not cross each other.
%[text] **In the IMM Filter case  (Step 2)**, the plot shows that the two tracks did not cross. This result is also evident in the break count of the true targets below, which shows zero breaks.
%[text] **In the custom IMM Filter case  (Step 3)**, the plot is similar to Step 2, but the metrics have changed due to the different distance method leveraged by the tracker during association.
disp(trackSummary)
disp(truthSummary)
%[text] In terms of tracking accuracy, the position and velocity errors of this tracker are similar to the ones from the combination of a single-hypothesis tracker with a constant velocity filter.
disp(trackMetrics)
disp(truthMetrics)

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":45.1}
%---
