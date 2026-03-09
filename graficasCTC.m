%% =========================================================
%  6 GRAFICAS INDEPENDIENTES - POSICION VS TIEMPO
%  - Completa espacios vacios con interpolacion
%  - Hace la curva mucho mas continua y suave
%  Archivo:
%  joint_states_2026-03-09_04-42-09.csv
%% =========================================================
clear; clc; close all;

%% 1) Cargar archivo
filename = 'joint_states_2026-03-09_04-42-09.csv';
T = readtable(filename, 'VariableNamingRule', 'preserve');

%% 2) Verificar columnas necesarias
requiredVars = {'time', ...
    'q_joint1','q_joint2','q_joint3','q_joint4','q_joint5','q_joint6'};

for k = 1:numel(requiredVars)
    if ~ismember(requiredVars{k}, T.Properties.VariableNames)
        error('Falta la columna requerida: %s', requiredVars{k});
    end
end

%% 3) Tiempo
t = T.time;
t = t - t(1);   % iniciar en 0 s

%% 4) Parametros
fs = 13;           
lw = 3.5;          
interpFactor = 300; 
smoothWin = 301;    

%% 5) Tiempo denso para interpolacion
t_dense = linspace(t(1), t(end), numel(t)*interpFactor);

%% 6) Graficar cada joint por separado
for i = 1:6
    
    % Señal original
    q = T.(sprintf('q_joint%d', i));
    
    % Completar espacios vacios si existen
    q_fill = fillmissing(q, 'spline');
    
    % Interpolar para "rellenar" visualmente los huecos entre muestras
    q_interp = interp1(t, q_fill, t_dense, 'spline');
    
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
    
    % Suavizado final
    q_smooth = smoothdata(q_interp, 'sgolay', win);
    
    %% Figura independiente
    figure('Name', sprintf('Joint %d', i), ...
           'Color', 'w', ...
           'Position', [100+25*i 90+20*i 950 520]);
    
    plot(t_dense, q_smooth, 'LineWidth', lw); hold on;
    plot(t, q, '.', 'MarkerSize', 7);
    
    grid on;
    xlabel('Tiempo [s]', 'FontSize', fs);
    ylabel(sprintf('q_{joint%d} [rad]', i), 'FontSize', fs);
    title(sprintf('Posicion suavizada e interpolada del Joint %d', i), 'FontSize', fs+2);
    legend('Curva continua e interpolada', 'Datos originales', 'Location', 'best');
    set(gca, 'FontSize', fs);
end