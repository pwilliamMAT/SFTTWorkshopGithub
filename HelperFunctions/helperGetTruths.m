function truths = helperGetTruths(trajCell,time)
truths = [];
for i = 1:length(trajCell) %
    traj = trajCell{i};
    id = i;
    [pos, orient, vel, acc, angVel] = lookupPose(traj,time,'ECEF');
    %ecef = lla2ecef(lla)
    thisTruth = helperAssembleTruth(trajCell,id,pos,orient,vel,acc,angVel);
    truths = [truths;thisTruth];    %#ok<AGROW>
end
end