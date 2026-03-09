%% =========================================================
%  6 DIAGRAMAS DE FASE INDEPENDIENTES
%  - X = posicion
%  - Y = velocidad
%  - Tiempo representado con color
%  - Completa huecos con interpolacion
%  - Mucha interpolacion + suavizado
%  - Con diagonal de referencia ("superficie")
%
%  Archivo:
%  joint_states_2026-03-09_01-06-20.csv
%% =========================================================
clear; clc; close all;

%% 1) Cargar archivo
filename = 'joint_states_2026-03-09_01-06-20.csv';
T = readtable(filename, 'VariableNamingRule', 'preserve');

%% 2) Verificar columnas necesarias
requiredVars = {'time', ...
    'q_joint1','q_joint2','q_joint3','q_joint4','q_joint5','q_joint6', ...
    'qd_joint1','qd_joint2','qd_joint3','qd_joint4','qd_joint5','qd_joint6'};

for k = 1:numel(requiredVars)
    if ~ismember(requiredVars{k}, T.Properties.VariableNames)
        error('Falta la columna requerida: %s', requiredVars{k});
    end
end

%% 3) Tiempo
t = T.time;
t = t - t(1);

%% 4) Parametros
fs = 13;
lw = 2.8;

interpFactor = 400;
smoothWin    = 201;

% Se recomienda true para que la diagonal tenga sentido visual
useNormalized = true;

%% 5) Tiempo denso
t_dense = linspace(t(1), t(end), numel(t)*interpFactor);

%% 6) Graficar cada joint por separado
for i = 1:6
    
    % Datos originales
    q  = T.(sprintf('q_joint%d', i));
    qd = T.(sprintf('qd_joint%d', i));
    
    % Completar huecos si existen
    q_fill  = fillmissing(q,  'spline');
    qd_fill = fillmissing(qd, 'spline');
    
    % Interpolacion densa
    q_interp  = interp1(t, q_fill,  t_dense, 'spline');
    qd_interp = interp1(t, qd_fill, t_dense, 'spline');
    
    % Ajustar ventana de suavizado
    win = smoothWin;
    if win >= length(q_interp)
        win = length(q_interp) - 1;
    end
    if mod(win,2) == 0
        win = win - 1;
    end
    if win < 5
        win = 5;
    end
    
    % Suavizado
    q_smooth  = smoothdata(q_interp,  'sgolay', win);
    qd_smooth = smoothdata(qd_interp, 'sgolay', win);
    
    % Normalizacion opcional
    if useNormalized
        x = q_smooth  - mean(q_smooth);
        y = qd_smooth - mean(qd_smooth);
        
        if max(abs(x)) > 0
            x = x ./ max(abs(x));
        end
        if max(abs(y)) > 0
            y = y ./ max(abs(y));
        end
        
        xLabelTxt = sprintf('q_{joint%d} normalizado', i);
        yLabelTxt = sprintf('qd_{joint%d} normalizado', i);
        titleTxt  = sprintf('Diagrama de fase normalizado - Joint %d', i);
    else
        x = q_smooth;
        y = qd_smooth;
        
        xLabelTxt = sprintf('q_{joint%d} [rad]', i);
        yLabelTxt = sprintf('qd_{joint%d} [rad/s]', i);
        titleTxt  = sprintf('Diagrama de fase - Joint %d', i);
    end
    
    %% Figura
    figure('Name', sprintf('Joint %d', i), ...
           'Color', 'w', ...
           'Position', [100+25*i 90+18*i 820 620]);
    
    hold on;
    grid on;
    
    % Limites bonitos para que la diagonal se vea completa
    if useNormalized
        lim = 1.15;
        xlim([-lim lim]);
        ylim([-lim lim]);
        axis equal;
        
        % Diagonal de referencia ("superficie")
        xd = linspace(-lim, lim, 200);
        yd = -xd;   % diagonal positiva
        
        % Si la quieres al reves, cambia por:
        % yd = -xd;
        
        plot(xd, yd, '--', 'LineWidth', 2.2);
    end
    
    % Curva suave
    plot(x, y, 'LineWidth', lw);
    
    % Progreso temporal con color
    scatter(x, y, 10, t_dense, 'filled');
    
    % Inicio y fin
    plot(x(1),   y(1),   'go', 'MarkerSize', 10, 'LineWidth', 2);
    plot(x(end), y(end), 'rs', 'MarkerSize', 10, 'LineWidth', 2);
    
    xlabel(xLabelTxt, 'FontSize', fs);
    ylabel(yLabelTxt, 'FontSize', fs);
    title(titleTxt, 'FontSize', fs+2);
    set(gca, 'FontSize', fs);
    colorbar;
    colormap turbo;
    
    legend('Superficie diagonal', 'Curva interpolada y suave', ...
           'Progreso temporal', 'Inicio', 'Fin', 'Location', 'best');
end