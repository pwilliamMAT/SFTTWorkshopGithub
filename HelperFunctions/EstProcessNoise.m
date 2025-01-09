function [velocityEst, accelerationEst] = EstProcessNoise(noisyDetections)

% Estimate Velocity and Acceleration from Detection Data:
% Velocity Estimate
deltaPos = norm(noisyDetections(2).Measurement - noisyDetections(1).Measurement);
deltaT = (noisyDetections(2).Time - noisyDetections(1).Time);
velocityEst = deltaPos/deltaT;

% Acceleration Estimate
deltaPos2 = norm(noisyDetections(4).Measurement - noisyDetections(3).Measurement);
deltaT2 = (noisyDetections(4).Time - noisyDetections(3).Time);
velocityEst2 = deltaPos2/deltaT2;
aveTime1 = (noisyDetections(2).Time + noisyDetections(1).Time)/2;
aveTime2 = (noisyDetections(4).Time + noisyDetections(3).Time)/2;
deltaTAve = aveTime2-aveTime1;
accelerationEst = (velocityEst2-velocityEst)/deltaTAve;

% Estimate the processNoise
%processNoise = accelerationEst^2/12 * eye(size(filter.ProcessNoise));

end