classdef PointLight
    properties
        Position(1,3) double = [0,0,0];
        Intensity(1,1) double {mustBePositive} = 15;
    end
    
    methods
        function obj = PointLight(position, intensity)
            if nargin > 0
                obj.Position = position;
                obj.Intensity = intensity;
            else
                obj.Position = [0,0,0];
                obj.Intensity = 15;
            end
        end
    end
end
