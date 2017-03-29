function cost = costOfWall(wallHeight, perimeter)
    costHeights = [30, 60, 95, 135, 180, 250, 340;
                    5, 7.5, 10, 12.5, 15, 17.5, 20];
                
    i = 2;
    while(i < length(costHeights))
       if (wallHeight < costHeights(2,i))
           break;
       end
       i = i + 1;
    end
    
    costWall = interpolate(costHeights(1,i-1), costHeights(1,i), costHeights(2,i-1), costHeights(2,i), wallHeight);
    
    cost = costWall * perimeter;
end
         
    