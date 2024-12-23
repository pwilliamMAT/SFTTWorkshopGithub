function filter = helperInitFilter(detection,knownSpeed)
% "initcvekf" uses the information within the detection object to populate
% the parameters that we adjusted manually in Exercise 2
filter = initcvekf(detection);
detectionMeasurementNoise = detection.MeasurementNoise;

% Set state covariance matrix diagonal according to the measurement noise and the known
% speed:
filter.StateCovariance = blkdiag(detectionMeasurementNoise(1),knownSpeed^2/3,detectionMeasurementNoise(1),knownSpeed^2/3, detectionMeasurementNoise(1),knownSpeed^2/3);

% Set Process Noise
errorVal = 150;
filter.ProcessNoise = eye(3)*(errorVal)^2;

% Adjust the state so the position is close to the detection and the
% velocity starts at zero (this will allow for the filter to dictate the
% direction via the sign)
% filter.State([2 4 6]) = 0; % Set Initial Velocities to zero
% filter.State([1 3 5]) = detectionPosition(:,1); % Set Initial position to initial detected position 

% Set filter measurement noise according to the detection measurement noise
%filter.MeasurementNoise = detectionMeasurementNoise;

end