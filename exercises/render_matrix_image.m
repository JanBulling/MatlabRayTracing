width = 100;
height = 80;

aspectRatio = width / height;

% initializing the pixels array
pixels = zeros(height, width, 3);

for y = 1:height
    for x = 1:width
        % converting from pixel coordinates to screen coordinates (0, 0) in
        % the lower left corner, (1, 1) in the upper right corner
        uvx = x / width;
        uvy = (1 - y / height) * 1 / aspectRatio;

        [r, g, b] = runOnPixel(uvx, uvy);

        pixels(y, x, 1) = r;
        pixels(y, x, 2) = g;
        pixels(y, x, 3) = b;

        % pause(0.001);
        % imshow(uint8(pixels));
        % drawnow;
    end
end

% display the image and convert back to "normal" RGB for matlab to render
imshow(uint8(pixels .* 255));


% ==================================================

% this function runs on every pixel that gets displayed. Pixel values are
% in RGB and range from 0 to 1 (which represents 255 in "normal" RGB)
function [r, g, b] = runOnPixel(uvx, uvy)
r = uvx;
g = uvy;
b = 1;
end