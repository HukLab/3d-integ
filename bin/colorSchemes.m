function cmap = colorSchemes(dotmode, name, N)
    color2d = [0.0 0.8 0.0];
    color3d = [0.8 0.0 0.0];
    switch dotmode
        case '2d'
            endColor = color2d;
            switch name
                case 'dur'
%                     startColor = [0.9 1.0 1.0];
                    startColor = [1.0 0.8 0.0];
                case 'coh'
%                     startColor = [0.9 1.0 1.0];
                    startColor = [0.0 0.8 1.0];
            end            
        case '3d'
            endColor = color3d;
            switch name
                case 'dur'
%                     startColor = [1.0 1.0 0.8];
                    startColor = [0.0 1.0 0.8];
                case 'coh'
%                     startColor = [1.0 1.0 0.8];
                    startColor = [1.0 0.0 0.8];
            end
        case 'both'
            cmap = {color2d, color3d};
            return;
    end
    cmap = colorGradient(N, startColor, endColor);
end
