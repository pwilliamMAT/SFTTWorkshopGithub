function mahCorrTruth = helperCalcMahalanobisDist_CV(truthPosition,cstates,cCov,time)
% Calculate Mahalanobis Distance - Position-Only (posnees) form:
% Corrected versus Truth
truthData = truthPosition([1 2],:); % Please delete when final dataset used

for i = 1:length(time)
    % % Const Velo
    e = cstates(i,[1 3])' - truthData(:,i);
    P = cCov([1 3],[1 3],i);
    mahCorrTruth(i) = sqrt(e'/P*e);
    
    % % Const Acc - 2D
    % e = cstates(i,[1 4])' - truthData(:,i);
    % P = cCov([1 4],[1 4],i);
    % mahCorrTruth(i) = sqrt(e'/P*e);

    % Const Acc - 3D
    % e = cstates(i,[1 4 7])' - truthPosition(:,i);
    % P = cCov([1 4 7],[1 4 7],i);
    % mahCorrTruth(i) = sqrt(e'/P*e);
end
end