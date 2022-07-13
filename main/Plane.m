classdef Plane < SceneObject
    properties
        Normal(1,3) double
        Color(1,3) double = [1,1,1]
    end
    
    methods
        function obj = Plane(position, normal, material, color)
            obj@SceneObject(position, material);
            obj.Normal = normal;
            obj.Color = color;
        end

        function [hit, dist] = intersect(this, origin, direction)
            dist = -1;

            denom = dot(this.Normal, direction);

            if (denom < 1e-6)
                p0l0 = this.Position - origin;
                dist = dot(p0l0, this.Normal) / denom;
                hit = dist > 0;
                return;
            end
            hit = false;
        end

        function normal = getNormal(this, hit)
            normal = this.Normal;
        end
    end
end