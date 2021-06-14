function[x2max] = GUI2D_safetylim(Glast,a)

if nargin == 1
    
    x2max = 20;
    
else
    
    x1max = 20;
    %Glast = [0 20 20 30 20 10]';
    %a = randn(6,1)';

    nbands = 6;
    x2max = 20;
    x2min = -20;

    Gainmax = 30;

    % Read in a, glast, x1 max, x2 max
    % return new x1 and x2 max
    % just in case for the future if we're mapping this differently 

    for iband =1:nbands
        if a(iband) > 0
            x2max_tmp = (Gainmax-Glast(iband)-x1max)/a(iband);
            if x2max_tmp < x2max
                x2max = x2max_tmp;
            end
        elseif a(iband) < 0
            x2min_tmp = (Gainmax-Glast(iband)-x1max)/a(iband);
            if x2min_tmp > x2min
                x2min = x2min_tmp;
            end
        end
    end
    x2max = min(abs(x2max), abs(x2min));    % take the smaller of the two

    % symmetric negative bounds
    x1min = -x1max;
    x2min = -x2max;
end
end

    
    

