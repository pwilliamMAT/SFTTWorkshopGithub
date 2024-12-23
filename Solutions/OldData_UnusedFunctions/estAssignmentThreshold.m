function AssignmentThreshold = estAssignmentThreshold(gateMult,noisyDetections)
% Gate input should be a multiplier on the measurementnoise - ie you expect
% your assignmentThreshold should be approx 5x MeasurementNoise

AssignmentThreshold = gateMult^2 + log(det(gateMult*noisyDetections(1).MeasurementNoise(1,1)));

end