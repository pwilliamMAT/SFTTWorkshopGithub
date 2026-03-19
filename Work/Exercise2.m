%[text] # Exercise 2: Track a Single Object without Clutter
%[text] In this exercise, you'll learn how to configure and use an extended Kalman filter (EKF) with a constant velocity model to track a short segment of a small piece of debris moving at a speed of ~5 km/s. You will tune the EKF to improve the state estimate and learn how to use different motion models with the filter.
%[text:tableOfContents]{"heading":"Table of Contents"}
%[text] ## **Load Data**
%[text] Let's load the truth and detection data from the previous example. The measurement represents the position of the truth, and its associated covariance is provided in the data. 
% Inspect the data
S = load('SpaceDebrisOneTarget.mat');
data = S.data;
disp(data);
%%
%[text] ## **Configure and Run the Filter**
%[text] In this section, you'll learn the interface to use an EKF with a constant velocity model to track the space debris object. The example uses an EKF to demonstrate the interface; however, a linear Kalman filter will also produce the exact results in this case because the measurements (positions) are simply a linear function of the state. 
%[text] ### Filter Initialization Function
%[text] The filter initialization function is a MATLAB function that helps start a new tracking filter from a detection. The function essentially informs the tracking algorithm of the following:
%[text] 1. Which filter type (EKF, UKF, etc.) to use?
%[text] 2. What motion and measurement models to choose?
%[text] 3. What are the initial state and initial state covariance?
%[text] 4. What are the measurement and process noise covariances? \
%[text] The input to the function is an object of type `objectDetection`. You'll see how to create an `objectDetection` from measurement data in the next section. The toolbox provides several filter initialization functions out of the box. Review the functional interface of the function using an example filter initialization function defined below.
% Define a function that initializes a filter from a detection.  %[text:anchor:M_98fb]
function filter = initFilter(detection)
    % This function wraps the shipping function initcvekf to demonstrate
    % the interface of filter initialization functions. 
    %
    % The initcvekf function defines a constant velocity (cv) extended
    % Kalman filter (ekf) from an objectDetection. 
    % 
    % CV model details:
    %
    % State (x) convention is [x;vx;y;vy;z;vz].
    % Process noise (w) convention is [ax;ay;az].
    
    % Initialize constant-velocity EKF
    filter = initcvekf(detection);
    
    % You can configure the parameters of your filter during
    % initialization, such as process noise (Q) and initial state
    % covariance (P).
    
    % Update the initial velocity covariance
    filter.StateCovariance([2 4 6],[2 4 6]) = 50e4*eye(3);

    % Update the process noise 
    filter.ProcessNoise = 1e3*eye(3);
end
%[text] ### Filtering Workflow and Loop
%[text] In this section, you'll create and initialize a filter using the function defined above. Then, you'll run the filter's prediction and correction steps in a loop to track the object.
% Create a display (Optional)
display = createDisplay(data.TruthPosition);

% Create an objectDetection from the first measurement
detection = objectDetection(data.Time(1),data.Measurement(1,:),...
                            'MeasurementNoise',data.MeasurementNoise{1});
%[text] <u>Coding Directions:</u>
%[text] **Step 1:** Initialize the tracking filter using the custom filter initialization function "initFilter" defined above. This should be done by passing "detections" to "initFlter" and assigning the output to the variable "filter", which is used below. **Then run the section to visualize results.**
%[text] **Step 2:** Adjust the filter parameters, especially the state covariance and process noise, within the "initFilter" to tune the fitler to the data. **Then run the section to visualize results.**
%[text] **Step 3:** Change the filter initialization function used within "initFilter" to use a UKF by using "initcvukf". **Then run the section to visualize results.**
%[text] **BONUS:** Try other filter initialization functions. [See "Initialization" section here.](https://www.mathworks.com/help/fusion/referencelist.html?type=function&s_tid=CRUX_topnav)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WRITE YOUR CODE HERE:

%[text] Loop Through Data to Run Filter
% Loop over the rest of the measurements using prediction and correction
for n = 2:length(data.Time)
    % Plot input data at current step
    plotData(display, data, n);
    
    % Time elapsed from last step
    dT = data.Time(n)-data.Time(n-1);

    % --- Predict the filter dT time ahead --- %
    predict(filter, dT);

    % Measurement data at current step
    z = data.Measurement(n,:);
    R = data.MeasurementNoise{n};
    
    % Update filter's measurement noise covariance
    filter.MeasurementNoise = R;

    % Compute innovation and covariance (only for Gaussian filters)
    [r, S] = residual(filter, z);
    filterNIS = r'/S*r;

    % Compute distance from the measurement using filter's method
    % d = r'/S*r + log(|S|) 
    % r = innovation, S = innovation covariance
    d = distance(filter, z);

    % Plot prediction (Optional)
    plotPrediction(display, filter, filterNIS);

    % Correct the filter with the current measurement. Optionally guard it
    % using the distance 
    correct(filter, z);
    
    % Plot correction (Optional)
    plotCorrection(display, filter);

    % Refresh display
    drawnow;
end
%%
%[text] # **Takeaways**
%[text] - Learned how to use the filter API.
%[text] - Learned how to tune the filter in a filter initialization function.
%[text] - Explored the library of built-in initialization functions. \
%%
%[text] ## Supporting Functions for Visualization
function display = createDisplay(truthPosition)
% This function creates the display for visualizing tracks, detections, and
% ground truth. 

f = figure;

theaterPanel = uipanel(f,'Units','normalized','Position',[0 0 0.5 1]);
distancePanel = uipanel(f,'Units','normalized','Position',[0.5 0 0.5 1]);
distanceAx = axes(distancePanel);
theaterAx = axes(theaterPanel);

% Create a struct to hold display objects
display = struct;

% Create a theater plot
display.TheaterPlot = theaterPlot('XLimits',[-2276567 37483],...
                                   'YLimits',[-6360820 -4348538],...
                                   'ZLimits',[2e6 5e6],...
                                   'Parent',theaterAx);

% Truth trajectory plotter
display.TrajectoryPlotter = trajectoryPlotter(display.TheaterPlot,...
                                              'DisplayName','True Trajectory',...
                                              'LineWidth',1,...
                                              'LineStyle','-',...
                                              'Color','k');

% Current truth position plotter
display.TruthPlotter = platformPlotter(display.TheaterPlot,...
                                        'DisplayName','Truth Position',...
                                        'MarkerFaceColor','k',...
                                        'MarkerEdgeColor','k');


% Detection plotter
display.DetectionPlotter = detectionPlotter(display.TheaterPlot,...
                                            'HistoryDepth',1e3,...
                                            'DisplayName','Detection',...
                                            'MarkerSize',10,...
                                            'MarkerFaceColor','r');

% Prediction plotter
display.PredictionPlotter = trackPlotter(display.TheaterPlot,...
                                        'HistoryDepth',1e3,...
                                        'DisplayName','Prediction',...
                                        'MarkerSize',10,...
                                        'MarkerFaceColor','b',...
                                        'MarkerEdgeColor','b',...
                                        'ConnectHistory','on');

% Correction plotter
display.CorrectionPlotter = trackPlotter(display.TheaterPlot,...
                                        'HistoryDepth',1e3,...
                                        'DisplayName','Correction',...
                                        'MarkerSize',10,...
                                        'MarkerFaceColor','g',...
                                        'MarkerEdgeColor','g',...
                                        'ConnectHistory','on');

% Distance plotter as a simple line
display.DistancePlotter = plot(distanceAx,nan,nan,'LineWidth',2);

% Plot Truth As Trajectory
plotTrajectory(display.TrajectoryPlotter,{truthPosition})
grid on, box on; 

legend(theaterAx,'Location','northeastoutside')

% Add Title and Rotate to 2D view
title(theaterAx,'Scenario View'); 
grid(theaterAx,'on');
view(theaterAx,[0 90.00]) % Rotate to 2D view

% Add Title and Rotate to 2D view
title(distanceAx,'Filter Consistency'); 
grid(distanceAx,'on');
xlabel(distanceAx,'Time step');
ylabel(distanceAx,'NIS');

f.Units = 'normalized';
f.Position = [0.1 0.1 0.8 0.5];

end

function plotPrediction(display, filter, dist)
% Collect position and position covariance estimates from the filter
stateStruct = struct('State',filter.State,'StateCovariance',filter.StateCovariance);

% Name of the model used by the filter. Convert function to string
modelName = func2str(filter.StateTransitionFcn);
[position, positionsCov] = getTrackPositions(stateStruct, modelName);

% Plot predicted position and covariance
trkID = 1; % For connecting trajectories
plotTrack(display.PredictionPlotter,position,positionsCov,trkID);

n = max(0,display.DistancePlotter.XData(end));
display.DistancePlotter.XData = [display.DistancePlotter.XData n+1];
display.DistancePlotter.YData = [display.DistancePlotter.YData dist];

end

function plotCorrection(display, filter)
% Collect position and position covariance estimates from the filter
stateStruct = struct('State',filter.State,'StateCovariance',filter.StateCovariance);

% Name of the model used by the filter. Convert function to string
modelName = func2str(filter.StateTransitionFcn);
[position, positionsCov] = getTrackPositions(stateStruct, modelName);

% Plot predicted position and covariance
trkID = 1 ; % For connecting trajectories
plotTrack(display.CorrectionPlotter,position,positionsCov,trkID);
end

function plotData(display, data, n)
% Plot current truth position
truthPos = data.TruthPosition(n,:);
display.TruthPlotter.plotPlatform(truthPos);

% Plot measurement position and covariance
z = data.Measurement(n,:);
R = data.MeasurementNoise{n};
plotDetection(display.DetectionPlotter,z,R);
end
%[text] 

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":37.5}
%---
