function filter = helperInitFilterMulti(detection)

filter = initcvekf(detection);

% State Covariance
% 2,4,6 = (Max Velocity^2)/12 -> show the tracker how fast the target can move, default (100) is way off

% Find indices for the diagonal
[m, n] = size(filter.StateCovariance); 
diagIndx = 1:(m+1):min(m*n, m*n); % Full diag
velocityIndx = diagIndx(2:2:size(diagIndx,2)); % indices for velocity on the diagonal
filter.StateCovariance(velocityIndx) = ones(size(velocityIndx))*(2.5e4)^2; % Assume a uniform distribution intially (set velocities to variance)

% Process Noise
%ScaleValue = 1e-3; % This is too small - (Max Acceleration^2)/12 of targets (delta Velocity/ deltaT between 2 points)
%filter.ProcessNoise = ScaleValue*eye(size(filter.ProcessNoise));
filter.ProcessNoise = (2e2)^2* eye(size(filter.ProcessNoise)); %accelerationEst^2/12 * eye(size(filter.ProcessNoise)); % Assume a uniform distribution intially (set Acceleration to variance)
disp('check')
end
