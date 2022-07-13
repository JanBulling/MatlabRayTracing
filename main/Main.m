% Rendering takes up to 5min. Deaktivate "fastRender" to see live progress.
% A fast version of the same code is available at 
% https://www.shadertoy.com/view/7sdBRX
% This code runs with 60 fps on the local GPU.

% ==== Meta Data ============================================
clear; %clf;

% accelerates the rendering process by not showing the live render process
fastRender = false;

bounces = 2;

width = 640;
height = 480;

% ==== Globals ============================================================
%                               position  zoom
global camera; camera = Camera([0, 0.1, -3],0.6);

%                                 position      intensity
global light; light = PointLight([0., 0.1, -0.25], 25);

global backgroundColor; backgroundColor = [0.2, 0.2, 0.2];


% ==== Setup ==============================================================
% initializing the pixels array
pixels = zeros(height, width, 3);

% generating scene
material1 = Material(0.4, 0.5, 120.0, 0.5);
material2 = Material(0.6, 0.2, 50.0, 0.1);

%                     Position     Radius   Material      Color
objects(1) = Sphere([0.25, 0.1, 0.], 0.2, material1, [0.2, 0.2, 0.2]);
objects(2) = Sphere([-0.25, 0.0, 0.], 0.2, material1, [0.3, 0.05, 0.05]);

%                     Position      Normal    Material        Color
objects(3) = Plane([0., -0.2, 0.], [0, 1, 0], material2, [0.36, 0.22, 0.07]);
objects(4) = Plane([-0.5, 0., 0.], [1, 0, 0], material2, [0.7, 0.7, 0.7]);
objects(5) = Plane([0.5, 0., 0.], [-1, 0, 0], material2, [0.7, 0.7, 0.7]);
objects(6) = Plane([0., 0.5, 0.], [0, -1, 0], material2, [0.2, 0.5, 0.6]);
objects(7) = Plane([0., 0., 0.3], [0, 0, -1], material2, [0.7, 0.7, 0.3]);
objects(8) = Plane([0., 0., -0.8], [0, 0, 1], material2, [0.6, 0.6, 0.2]);

 

% ==== Render =============================================================
aspectRatio = width / height;
bounces = min(2, max(0, bounces));
for y = 1:height
    for x = 1:width
        % converting from pixel coordinates to screen coordinates (0, 0) in
        % the lower left corner, (1, 1) in the upper right corner
        uvx = (2 * (x + 0.5) / width - 1);
        uvy = (1 - 2 * (y + 0.5) / height) * 1 / aspectRatio;

        [r, g, b] = runOnPixel(uvx, uvy, objects, bounces);

        pixels(y, x, 1) = r;
        pixels(y, x, 2) = g;
        pixels(y, x, 3) = b;
    end

    if (~fastRender)
        imshow(uint8(pixels .* 255));
        drawnow;
    end
end

% display the image and convert back to "normal" RGB for matlab to render
imshow(uint8(pixels .* 255));



% =========================================================================
% ==== Functions ==========================================================
% =========================================================================

% this function runs on every pixel that gets displayed. Pixel values are
% in RGB and range from 0 to 1 (which represents 255 in "normal" RGB)
function [r, g, b] = runOnPixel(uvx, uvy, objects, bounces)
global camera;

origin = camera.Position;
rayDirection = unitVec([uvx, uvy, camera.Zoom] - camera.Position);

[r, g, b] = castRay(origin, rayDirection, objects, bounces);

end



% ==== Ray Tracing ========================================================

% computes the color
function [r, g, b] = castRay(origin, rayDirection, objects, bounces)
global backgroundColor; global light;

finalColor = backgroundColor;

prevIndex = -1;

for i = 1:bounces
    minDist = 1000000;
    minDistIndex = -1;

    for j = 1:length(objects)

        if (j == prevIndex)
            continue;
        end

        [hit, dist] = objects(j).intersect(origin, rayDirection);
        if (hit && dist < minDist)
            minDist = dist;
            minDistIndex = j;
        end
    end

    if (minDistIndex ~= -1)
        closestObj = objects(minDistIndex);

        hitPosition = origin + rayDirection * minDist;
        normalVec = closestObj.getNormal(hitPosition);

        passColor = getColor(closestObj, light, hitPosition, normalVec, rayDirection);

        if (i == 1 || prevIndex == -1)
            finalColor = passColor;
        else
            prevObject = objects(prevIndex);
            finalColor = finalColor + prevObject.Material.Specular * passColor;
        end
    
        origin = hitPosition;
        rayDirection = unitVec(reflect(rayDirection, normalVec));
        prevIndex = minDistIndex;
    else
        break;
    end
end

r = finalColor(1);
g = finalColor(2);
b = finalColor(3);

end

function color = getColor(object, light, hitPoint, normalVec, rayDirection)
    material = object.Material;
    objColor = object.Color;

    lightVec = hitPoint - light.Position;
    lightDir = unitVec(lightVec);

    % dependened on the distance to the light source
    lightIntensity = (0.01 * light.Intensity) / abs(dot(lightVec, lightVec));

    reflCoeff = max(0, -dot(lightDir, normalVec));
    
    ambient = objColor .* material.Ambience;
    diffuse = (material.Diffuse * reflCoeff * lightIntensity) .* objColor;

    shininess = max(...
        -dot(reflect(lightDir, normalVec), rayDirection),...
        0) ^ material.Shininess;
    specular = (material.Specular * shininess * lightIntensity) .* objColor;

    color = ambient + diffuse + specular;
end


% ===== Maths =============================================================
function res = unitVec(vec)
res = vec ./ norm(vec);
end

function ref = reflect(vec, normal)
ref = vec - 2 * dot(vec, normal) .* normal;
end

