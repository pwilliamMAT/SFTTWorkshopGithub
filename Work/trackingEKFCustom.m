classdef trackingEKFCustom < trackingEKF

    methods
        function d = distance(obj, z_matrix, measurementParams)
            if nargin < 3
                measurementParams = {};
            end

            if isvector(z_matrix)
                z_matrix = z_matrix(:);
            end

            numMeas = size(z_matrix, 2);
            d = zeros(1, numMeas, 'like', z_matrix);
            for i = 1:numMeas
                [res, S] = residual(obj, z_matrix(:,i), measurementParams);
                d(i) = sqrt(real(res' / S * res));
            end
        end
    end
end
