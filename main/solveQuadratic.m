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