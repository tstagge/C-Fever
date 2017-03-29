function y = interpolate(y1,y2,x1,x2,x)
    y = ( ((y2 - y1) * (x - x1)) / (x2 - x1) ) + y1;
end