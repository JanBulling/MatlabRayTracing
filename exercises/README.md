# A step-by-step guide to understand for the Project

## Render an image

The first thing is to draw an image from pixels. To do so, you create an matlab array for every pixel (3 color chanels)
```matlab
pixels = zeros(height, width, 3);
```
Matlab expects the colors to be in an RGB format with values from 0 to 255. But normaly you store the color values in a range between 0 and1 (it is easier for calculations).
To display the pixels array as an image, simply call
```matlab
imshow(uint8(pixels .* 255));
```

Example for this can be seen [here](https://github.com/JanBulling/MatlabRayTracing/exercises/render_matrix_image.m).

## Basic Ray Tracing
To test the ray tracing implementation, we can simply color a pixel differently, if a ray hits the sphere at this pixel.
The ray direction to hit a specifiy pixel at $x$ and $y$ is given by $[x,y,-1]$. To check if the ray intersects with the sphere, you only need to chek if the qudratic formula
with the following parameters has a solution.
$$a = rayDirection \cdot rayDirection$$
$$b = 2 * (cameraPosition \cdot rayDirection)$$
$$c = (cameraPosition \cdot cameraPosition) - radius^2$$

You can see an example in matlab [here](https://github.com/JanBulling/MatlabRayTracing/exercises/basic_ray_tracing.m).

## Sphere Ray Tracing
The solutions of the quadratic equation are the distance from the ray origin (the "camera position") to the intersection point. The nearest intersection point is the first hit 
of the objet. To color the object, you can for example take the dot product of the ray direction and the normal vector of the sphere at the hit point. An example like
this can be seen [here](https://github.com/JanBulling/MatlabRayTracing/exercises/one_sphere_ray_tracing.m).
