% ==== Meta Data ============================================
width = 300;
height = 300;

aspectRatio = width / height;

% ==== Globals ==============================================
global cameraPosition; cameraPosition = [0,0,2];
global backgroundColor; backgroundColor = [0.2, 0.2, 0.2];

global sphereRadius; sphereRadius = 0.3;
global spherePosition; spherePosition = [0, 0, 0];
global sphereColor; sphereColor = rand(1,3);



% initializing the pixels array
pixels = zeros(height, width, 3);

for y = 1:height
    for x = 1:width
        % converting from pixel coordinates to screen coordinates (0, 0) in
        % the lower left corner, (1, 1) in the upper right corner
        uvx = (2 * (x + 0.5) / width - 1);
        uvy = (1 - 2 * (y + 0.5) / height) * 1 / aspectRatio;

        [r, g, b] = runOnPixel(uvx, uvy);

        pixels(y, x, 1) = r;
        pixels(y, x, 2) = g;
        pixels(y, x, 3) = b;
    end
end

% display the image and convert back to "normal" RGB for matlab to render
imshow(uint8(pixels .* 255));



% =========================================================================
% ==== Functions ==========================================================
% =========================================================================

% this function runs on every pixel that gets displayed. Pixel values are
% in RGB and range from 0 to 1 (which represents 255 in "normal" RGB)
function [r, g, b] = runOnPixel(uvx, uvy)
global cameraPosition; global sphereRadius; global spherePosition;

rayDirection = unitVec([uvx, uvy, -1] - cameraPosition);

[r, g, b] = castRay(cameraPosition, rayDirection, ...
    spherePosition, sphereRadius);

end



% ==== Ray Tracing ========================================================

% computes the color
function [r, g, b] = castRay(origin, direction, spherePos, sphereR)
global sphereColor; global backgroundColor;

[hit, dist] = trace(origin, direction, spherePos, sphereR);
if (hit)
    hitPosition = origin + direction * dist;
    normalVec = calculateNormalVec(hitPosition, spherePos);

    color = sphereColor .* max(0.0, -dot(normalVec, direction));

    r = color(1);
    g = color(2);
    b = color(3);
else
    r = backgroundColor(1);
    g = backgroundColor(2);
    b = backgroundColor(3);
end

end


% returns wheter it hit the sphere or not. If it did hit, it also returns
% the distance from the camera to the intersection
function [hit, dist] = trace(origin, direction, spherePos, sphereR)
dist = -1; hit = false;         % default values

l = origin - spherePos;
a = dot(direction, direction);
b = 2.0 * dot(l, direction);
c = dot(l, l) - sphereR^2;

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


% ===== Maths =============================================================
% solves a quadratic equation in the form of ax^2 + bx + c = 0
function [solvable, x0, x1] = solveQuadratic(a, b, c)
x0 = 0; x1 = 0; solvable = false;       % default values

discr = b^2 - 4.0 * a * c;

if (discr < 0)
    solvable = false;
    return;
elseif (discr == 0) 
    x0 = -b / (2 * a); x1 = x0;
    solvable = true;
    return;
else
    x0 = (-b + sqrt(discr)) / (2.0 * a);
    x1 = (-b - sqrt(discr)) / (2.0 * a);
    solvable = true;
end

end

% calculates the normal vector at a given point on the sphere
function normal = calculateNormalVec(hitPosition, center)
normal = unitVec(hitPosition - center);
end

function res = unitVec(vec)
res = vec ./ norm(vec);
end



