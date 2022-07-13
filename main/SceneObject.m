classdef SceneObject < matlab.mixin.Heterogeneous

properties
    Position(1, 3) double
    Material(1,1) Material
end

methods
    function obj = SceneObject(position, material)
        obj.Material = material;
        obj.Position = position;
    end

    function [hit, dist] = intersect(this, origin, rayDirection)
        hit = false;
        dist = -1;
    end

    function normal = getNormal(this, hit)
        normal = [0,0,0];
    end
end

end