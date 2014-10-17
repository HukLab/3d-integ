function cmap = colorSchemes(dotmode, name, N)
    color2d = [0.2 0.4 1.0]; % endColor
    color3d = [0.9 0.1 0.1]; % endColor
    switch dotmode
        case '2d'
            endColor = color2d;
            switch name
                case 'dur'
                    startColor = [1.0 0.8 0.0];
                case 'coh'
                    startColor = [0.7 0.8 1.0];
                case 'surf'
                    startColor = [1.0 1.0 1.0];
                    endColor = [0.3 0.3 0.6];
            end            
        case '3d'
            endColor = color3d;
            switch name
                case 'dur'
                    startColor = [1.0 0.9 0.4];
                case 'coh'
                    startColor = [1.0 0.8 0.8];
                case 'surf'
                    startColor = [1.0 1.0 1.0];
                    endColor = [0.6 0.3 0.3];
            end
        case 'both'
            cmap = {color2d, color3d};
            return;
    end
    cmap = colorGradient(N, startColor, endColor);
end
