function plotcube(cubeSize, origin, alpha, color)
    % Analyse der Eingabeparameter
    if nargin < 4
        color = [0 0 1]; 
    end
    if nargin < 3
        alpha = 1; 
    end

    % Berechnung der Koordinaten der Scheitelpunkte eines rechteckigen Körpers
    vertices = [origin;
                origin + [0 0 cubeSize(3)];
                origin + [0 cubeSize(2) 0];
                origin + [0 cubeSize(2) cubeSize(3)];
                origin + [cubeSize(1) 0 0];
                origin + [cubeSize(1) 0 cubeSize(3)];
                origin + [cubeSize(1) cubeSize(2) 0];
                origin + cubeSize];

    % Zeichnung der Seiten eines Rechtecks
    edges = [1 2; 1 3; 1 5; 2 4; 2 6; 3 4; 3 7; 4 8; 5 6; 5 7; 6 8; 7 8];
    for i = 1:size(edges, 1)
        x = vertices(edges(i, :), 1);
        y = vertices(edges(i, :), 2);
        z = vertices(edges(i, :), 3);
        plot3(x, y, z, 'Color', color, 'LineWidth', 2);
        hold on;
    end

    % Einstellen der Transparenz des Rechteckes
    if isscalar(alpha)
        alphaValue = alpha * ones(1, size(vertices, 1));
    else
        alphaValue = alpha;
    end

    % Zeichnen der Flächen eines Rechteckes
    faces = [1 3 7 5;
             1 3 4 2;
             1 2 6 5;
             2 4 8 6;
             3 4 8 7;
             5 6 8 7];
    patch('Vertices', vertices, 'Faces', faces, 'FaceColor', 'w', 'FaceAlpha', 0.3);
    axis equal;
    hold off;
end

