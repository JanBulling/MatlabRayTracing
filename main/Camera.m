classdef Camera
    properties
        Position(1,3) double = [0,0,0];
        Zoom(1,1) double = 0.7;
    end
    
    methods
        function obj = Camera(position, zoom)
            if nargin > 0
                obj.Position = position;
                obj.Zoom = zoom;
            else
                obj.Position = [0.0, 0.0, 0];
                obj.Zoom = 0.7;
            end
        end
    end
end

