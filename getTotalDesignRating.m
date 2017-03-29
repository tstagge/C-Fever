function tdr = getTotalDesignRating(eIn, cTotal)
    eOut = 12; %MWh (assumed a constant, desired output for all designs)
    nTotal = eOut/eIn;
    tdr = nTotal/cTotal;
end