width = 300;
height = 300;

aspectRatio = width / height;

global cameraPosition; cameraPosition = [0, 0, 1];

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


% ==================================================

% this function runs on every pixel that gets displayed. Pixel values are
% in RGB and range from 0 to 1 (which represents 255 in "normal" RGB)
function [r, g, b] = runOnPixel(uvx, uvy)
global cameraPosition;

rayDirection = [uvx, uvy, -1.0];
radius = 0.5;

a = dot(rayDirection, rayDirection);
b = 2.0 * dot(cameraPosition, rayDirection);
c = dot(cameraPosition, cameraPosition) - radius^2;

discriminant = b^2 - 4.0 * a * c;

if discriminant >= 0
    r = 1; g = 0; b = 1;
else
    r = 0; g = 0; b = 0;
end

end



