classdef Material
    properties
        Ambience(1,1) double {mustBePositive} = 0.1   % ambient lighting of
        Diffuse(1,1) double {mustBePositive} = 0.5   % how much light gets scattered around
        Specular(1,1) double {mustBePositive} = 0.5  % how much light gets reflected
        Shininess(1,1) double {mustBePositive} = 5.0  % reflectivness
    end
    
    methods
        function obj = Material(diffuse, specular, shininess, ambience)
            if nargin > 0
                obj.Ambience = ambience;
                obj.Diffuse = diffuse;
                obj.Specular = specular;
                obj.Shininess = shininess;
            else
                obj.Ambience = 0.1;
                obj.Diffuse = 0.5;
                obj.Specular = 0.5;
                obj.Shininess = 5.0;
            end
        end
    end
end
