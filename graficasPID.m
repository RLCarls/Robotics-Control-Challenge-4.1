%% =========================================================
%  GRAFICAR 6 JOINTS CONTINUOS Y SUAVES
%  - Solo posicion vs tiempo
%  - Rellena visualmente con interpolacion
%  - Suaviza para que se vea continua
%  Archivo:
%  joint_states_2026-03-09_01-06-20.csv
%% =========================================================
clear; clc; close all;

%% 1) Cargar archivo
filename = 'joint_states_2026-03-09_01-06-20.csv';
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

%% 4) Parametros visuales
fs = 13;          % tamaño de texto
lw = 3.2;         % grosor de linea
interpFactor = 40; % cuantas veces mas puntos quieres para "rellenar"

%% 5) Tiempo denso para interpolacion
t_dense = linspace(t(1), t(end), numel(t)*interpFactor);

%% 6) Graficar cada joint por separado
for i = 1:6
    
    % Señal original del joint
    q = T.(sprintf('q_joint%d', i));
    
    % Si en futuros CSV hay NaN, esto los rellena
    q_fill = fillmissing(q, 'pchip');
    
    % Interpolacion para rellenar visualmente los espacios
    % 'pchip' da una curva suave sin exagerar tanto como spline
    q_interp = interp1(t, q_fill, t_dense, 'pchip');
    
    % Suavizado adicional
    win = 61;   % mas grande = mas suave
    if win >= length(q_interp)
        win = length(q_interp) - 1;
    end
    if mod(win,2) == 0
        win = win - 1;
    end
    if win < 5
        win = 5;
    end
    
    q_smooth = smoothdata(q_interp, 'sgolay', win);

    %% Figura
    figure('Name', sprintf('Joint %d', i), ...
           'Color', 'w', ...
           'Position', [120+30*i 100+20*i 950 500]);

    % curva original tenue (opcional, para comparar)
    plot(t, q, '.', 'MarkerSize', 8); hold on;
    
    % curva continua y suave
    plot(t_dense, q_smooth, 'LineWidth', lw);
    
    grid on;
    xlabel('Tiempo [s]', 'FontSize', fs);
    ylabel(sprintf('q_{joint%d} [rad]', i), 'FontSize', fs);
    title(sprintf('Posicion continua y suavizada del Joint %d', i), 'FontSize', fs+2);
    legend('Muestras originales', 'Curva interpolada y suavizada', 'Location', 'best');
    set(gca, 'FontSize', fs);
end