function truth = helperAssembleTruth(obj,id,pos,orient,vel,acc,angVel) %#ok<INUSL>
if isnan(pos)
    pos = {};
    orient = {};
    id = {};
    vel = {};
    acc = {};
    angVel = {};
end
truth = struct('PlatformID',id,...
    'Position',pos,...
    'Velocity',vel,...
    'Orientation',orient,...
    'Acceleration',acc,...
    'AngularVelocity',angVel);

end