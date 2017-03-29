function tdr = getTotalDesignRating(Ein, cTotal)
    Eout = 12; %MWh (assumed a constant, desired output for all designs)
    nTotal = Eout/Ein;
    tdr = nTotal/cTotal;
end