function x2 = x2_values(a,Glast,x1)

for band = 1:6 
    Glast_band = Glast(band,1);
    a_band = a(band,1);
    
    if a_band > 0
        x2 = (30 - Glast_band - x1)/a_band;
    elseif a_band < 0 
        x2 = (30 - Glast_band - x1)/a_band;
    end
        
end


end