classdef Sphere < SceneObject
    properties
        Radius(1,1) double {mustBePositive} = 0.5
        Color(1,3) double = [1,1,1]
    end

    methods
        function obj = Sphere(position, radius, material, color)
            obj@SceneObject(position, material);
            obj.Radius = radius;
            obj.Color = color;
        end

        function [hit, dist] = intersect(this, origin, rayDirection)
            dist = -1; hit = false;         % default values

            L = origin - this.Position;
            a = dot(rayDirection, rayDirection);
            b = 2.0 * dot(L, rayDirection);
            c = dot(L, L) - this.Radius^2;
            
            [solvable, x0, x1] = solveQuadratic(a, b, c);
            
            if (~solvable)
                hit = false;
                return;
            end
            
            % make sure, x0 is the smaller of the two
            if x0 > x1
                temp = x0; x0 = x1; x1 = temp;
            end
            
            if (x0 < 0)     % if x0 is negative (behind the camera), try x1
                x0 = x1;
                if (x0 < 0) % if x0 is still < 0, all hits are behind the camera
                    hit = false;
                    return;
                end
            end
            
            dist = x0;
            hit = true;
        end

        function normal = getNormal(this, hit)
            normal = hit - this.Position;
            normal = normal ./ norm(normal);
        end
    end
end