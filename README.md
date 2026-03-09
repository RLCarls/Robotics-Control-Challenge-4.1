# Robotics Control Challenge 4.1

Proyecto integral de control de robótica que implementa cinemática, dinámica y estrategias de control avanzadas para un brazo robótico de 6 grados de libertad (DOF). Incluye módulos para planificación de trayectorias, seguimiento de control PID y CTC, análisis de estabilidad, y visualización en tiempo real.

## 📋 Tabla de Contenidos

- [Descripción General](#descripción-general)
- [Características](#características)
- [Requisitos del Sistema](#requisitos-del-sistema)
- [Instalación](#instalación)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Guía de Uso](#guía-de-uso)
- [Parámetros Configurables](#parámetros-configurables)
- [Formato de Datos](#formato-de-datos)
- [Arquitectura del Sistema](#arquitectura-del-sistema)
- [Ejemplos de Uso](#ejemplos-de-uso)
- [Troubleshooting](#troubleshooting)
- [Licencia](#licencia)

## 📖 Descripción General

Este proyecto es una solución completa para la simulación y control de un brazo robótico industrial. Implementa tanto modelos cinemáticos como dinámicos, permitiendo validar diferentes estrategias de control (PID, CTC) y analizar su desempeño mediante diagramas de fase y gráficas de seguimiento.

El sistema está diseñado para:
- **Investigación académica**: Análisis de controladores en robótica
- **Desarrollo de algoritmos**: Prueba de nuevas estrategias de control
- **Validación experimental**: Comparación entre controladores teóricos

## ✨ Características

- ✅ Cinemática directa e inversa de 6 DOF
- ✅ Modelo dinámico con torques y fricción
- ✅ Controlador PID descentralizado por articulación
- ✅ Controlador CTC (Computed Torque Control) basado en modelo
- ✅ Generación automática de trayectorias (cuadrado, línea, etc.)
- ✅ Monitoreo y registro de estados en tiempo real
- ✅ Análisis de estabilidad mediante diagramas de fase
- ✅ Visualización 3D de trayectorias
- ✅ Cálculo de métricas de desempeño (error, energía, tiempo)

## 🖥️ Requisitos del Sistema

### Software

| Componente | Versión | Propósito |
|-----------|---------|----------|
| Python | 3.8+ | Scripts de control y visualización |
| NumPy | 1.19+ | Cálculos numéricos |
| Matplotlib | 3.3+ | Gráficas y visualización |
| SciPy | 1.5+ | Funciones científicas avanzadas |
| MATLAB | R2020b+ | Análisis y diagramas de fase |
| Pandas | 1.1+ | Manejo de datos CSV |

### Hardware

- CPU: Intel i5 / equivalente o superior
- RAM: Mínimo 4 GB
- Almacenamiento: 2 GB disponibles

## 📦 Instalación

### 1. Clonar el repositorio

```bash
git clone https://github.com/usuario/Robotics-Control-Challenge-4.1.git
cd Robotics-Control-Challenge-4.1
```

### 2. Crear entorno virtual (recomendado)

```bash
python3 -m venv env
source env/bin/activate  # En Windows: env\Scripts\activate
```

### 3. Instalar dependencias Python

```bash
pip install --upgrade pip
pip install numpy matplotlib scipy pandas
```

### 4. Verificar instalación

```bash
python3 -c "import numpy, matplotlib, scipy, pandas; print('✓ Dependencias instaladas correctamente')"
```

### 5. Configurar MATLAB (opcional)

Para análisis avanzado con diagramas de fase:
- Descargar MATLAB R2020b o superior
- Agregar la carpeta del proyecto al path de MATLAB: `addpath(genpath('/ruta/al/proyecto'))`

## 📁 Estructura del Proyecto

```
Robotics-Control-Challenge-4.1/
├── README.md                      # Este archivo
├── controller.py                  # Controladores (PID, CTC)
├── dynamics.py                    # Modelo dinámico del robot
├── kinematics.py                  # Cinemática directa e inversa
├── ik_solver.py                   # Resolvedor de IK especializado
├── joint_logger.py                # Registro de datos de articulaciones
├── distance_monitor.py            # Monitoreo de distancias y errores
├── square_maker.py                # Generador de trayectorias
├── plot_traj_3d.py                # Visualización 3D
├── diagramasdefaseCTC.m           # Análisis CTC
├── diagramasdefasePID.m           # Análisis PID
├── graficasCTC.m                  # Gráficas CTC
├── graficasPID.m                  # Gráficas PID
└── data/                          # Carpeta para archivos CSV
    ├── joint_states_*.csv         # Datos registrados
    └── trajectories/              # Trayectorias generadas
```

### Descripción Detallada de Archivos

#### **Módulo de Control** (`controller.py`)

Implementa las estrategias de control principales:

**Controlador PID (Proportional-Integral-Derivative)**
- Ganancia proporcional: `Kp`
- Ganancia integral: `Ki`
- Ganancia derivativa: `Kd`
- Para cada una de las 6 articulaciones
- Fórmula: $u(t) = K_p e(t) + K_i \int e(t)dt + K_d \frac{de(t)}{dt}$

**Controlador CTC (Computed Torque Control)**
- Basado en modelo dinámico
- Cancelación de no-linealidades
- Más robusto ante perturbaciones
- Requiere parámetros dinámicos precisos
- Fórmula: $\tau = M(q)u + C(q,\dot{q})\dot{q} + G(q) + f$

#### **Modelo Dinámico** (`dynamics.py`)

Define las ecuaciones del movimiento del robot:

```
Ecuación de Lagrange-Euler:
M(q)q̈ + C(q,q̇)q̇ + G(q) = τ + f
```

Donde:
- `M(q)`: Matriz de inercia
- `C(q,q̇)`: Matriz de Coriolis y centrífuga
- `G(q)`: Vector de gravedad
- `τ`: Torques aplicados
- `f`: Fricción

#### **Cinemática** (`kinematics.py`)

Conversión entre espacios cartesiano y articular:

- **Cinemática Directa (FK)**: $T = f_k(q)$ - Calcula posición/orientación desde ángulos
- **Cinemática Inversa (IK)**: $q = f_k^{-1}(T)$ - Calcula ángulos desde posición deseada
- Jacobiano: $v = J(q)\dot{q}$

#### **Resolvedor IK** (`ik_solver.py`)

Algoritmos especializados para solución de cinemática inversa:
- Método analítico (si es posible)
- Método numérico iterativo (Newton-Raphson)
- Validación de singularidades

#### **Registro de Datos** (`joint_logger.py`)

Captura estados durante la simulación:
- Tiempo de ejecución
- Posiciones articulares (`q`)
- Velocidades articulares (`q̇`)
- Aceleraciones articulares (`q̈`)
- Torques aplicados (`τ`)
- Errores de seguimiento
- Exporta a CSV/JSON

#### **Monitor de Distancia** (`distance_monitor.py`)

Análisis de desempeño del seguimiento:
- Error de posición en espacio cartesiano
- Error de trayectoria
- Distancia recorrida
- Velocidad promedio
- Métricas: IAE, ISE, ITAE

#### **Generador de Trayectorias** (`square_maker.py`)

Crea patrones de movimiento para validación:
- Trayectoria cuadrada en XY
- Interpolación polinomial (5to orden)
- Trayectorias circulares
- Perfiles de velocidad suave

Parámetros:
```python
square_size = 0.5  # metros
num_points = 100   # puntos intermedios
time_total = 20    # segundos
```

#### **Visualización 3D** (`plot_traj_3d.py`)

Gráficas y visualización de resultados:
- Trayectoria 3D del efector final
- Configuración del robot en diferentes instantes
- Comparación de error vs tiempo
- Animación (opcional)

#### **Análisis MATLAB - PID** (`diagramasdefasePID.m` y `graficasPID.m`)

Scripts de análisis especializado para controlador PID:

**Diagramas de Fase**:
- Gráfica posición vs velocidad (retrato de fase)
- Coloreado según tiempo
- Interpolación y suavizado
- Identificación visual de estabilidad
- Detección de ciclos límite

**Gráficas de Desempeño**:
- Seguimiento de posición deseada
- Error de posición en el tiempo
- Señal de control (torques)
- Energía consumida

#### **Análisis MATLAB - CTC** (`diagramasdefaseCTC.m` y `graficasCTC.m`)

Scripts de análisis para controlador CTC:

Mismas características que PID, pero optimizadas para evaluación de CTC:
- Mejor seguimiento esperado
- Análisis de robustez
- Comparación con PID

## 🚀 Guía de Uso

### Uso Básico: Paso a Paso

#### Paso 1: Configurar parámetros del robot

Editar los parámetros en el archivo de configuración o al inicio de los scripts:

```python
# Parámetros del robot (6 DOF)
ROBOT_DOF = 6
LINK_LENGTHS = [0.3, 0.4, 0.2, 0.1, 0.05, 0.05]  # metros
JOINT_LIMITS = [(-180, 180), (-90, 90), (-180, 180), 
                (-90, 90), (-180, 180), (-180, 180)]  # grados
```

#### Paso 2: Generar una trayectoria

```bash
python3 square_maker.py --size 0.5 --time 20 --output trajectory.csv
```

#### Paso 3: Simular con controlador PID

```bash
python3 controller.py --traj trajectory.csv --method PID \
        --Kp 100 --Ki 10 --Kd 50 --output results_pid.csv
```

#### Paso 4: Simular con controlador CTC

```bash
python3 controller.py --traj trajectory.csv --method CTC \
        --output results_ctc.csv
```

#### Paso 5: Visualizar resultados

```bash
python3 plot_traj_3d.py --data results_pid.csv --data results_ctc.csv
```

#### Paso 6: Análisis detallado con MATLAB

En MATLAB:
```matlab
% Análisis PID
diagramasdefasePID  % Crea diagrama de fase
graficasPID         % Crea gráficas de desempeño

% Análisis CTC
diagramasdefaseCTC  % Crea diagrama de fase
graficasCTC         % Crea gráficas de desempeño

% Comparación
figure; plot(T_pid, error_pid); hold on; plot(T_ctc, error_ctc);
legend('PID', 'CTC'); xlabel('Tiempo (s)'); ylabel('Error (m)');
```

## ⚙️ Parámetros Configurables

### Controlador PID (por articulación)

| Parámetro | Valor Por Defecto | Rango Recomendado | Descripción |
|-----------|------------------|-------------------|-------------|
| `Kp` | 100 | 50-200 | Ganancia proporcional |
| `Ki` | 10 | 0-50 | Ganancia integral |
| `Kd` | 50 | 20-100 | Ganancia derivativa |
| `dt` | 0.001 | 0.0001-0.01 | Paso de integración |
| `error_max` | 0.1 | 0.05-0.5 | Error máximo permitido |

**Sintonización recomendada (Ziegler-Nichols)**:
1. Establecer Ki=0, Kd=0
2. Incrementar Kp hasta oscilación sostenida
3. Anotar Ku (Kp crítico) y Tu (período)
4. Configurar: 
   - Kp = 0.6 × Ku
   - Ki = 1.2 × Ku / Tu
   - Kd = 0.075 × Ku × Tu

### Controlador CTC

| Parámetro | Valor | Descripción |
|-----------|-------|-------------|
| `link_mass` | Varía | Masa de cada eslabón |
| `link_inertia` | Varía | Tensor de inercia |
| `friction_coeff` | 0.1-0.5 | Coeficiente de fricción |
| `gravity` | 9.81 | Aceleración gravitacional |
| `Kp_ctc` | 10 | Ganancia proporcional del error |
| `Kd_ctc` | 5 | Ganancia derivativa del error |

### Planificación de Trayectoria

| Parámetro | Valor Por Defecto | Descripción |
|-----------|------------------|-------------|
| `square_size` | 0.5 m | Lado del cuadrado |
| `time_total` | 20 s | Duración total |
| `num_points` | 100 | Puntos intermedios |
| `velocity_profile` | quintic | Tipo de spline |
| `max_velocity` | Calculado | Velocidad máxima permitida |
| `max_acceleration` | Calculado | Aceleración máxima |

## 📊 Formato de Datos

### Archivo de Entrada: Trayectoria (CSV)

```csv
time,x,y,z,roll,pitch,yaw,vx,vy,vz,wx,wy,wz
0.0,0.5,0.0,0.8,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0
0.1,0.505,0.01,0.8,0.0,0.0,0.0,0.05,0.1,0.0,0.0,0.0,0.0
...
```

### Archivo de Salida: Estados Registrados (CSV)

```csv
time,q_joint1,q_joint2,q_joint3,q_joint4,q_joint5,q_joint6,
qd_joint1,qd_joint2,qd_joint3,qd_joint4,qd_joint5,qd_joint6,
torque_j1,torque_j2,torque_j3,torque_j4,torque_j5,torque_j6,
error_pos,error_vel,desired_q1,desired_q2,desired_q3,desired_q4,desired_q5,desired_q6
0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0
0.001,0.0001,0.0002,...
```

### Columnas en Datos de Salida

- `time`: Instante de tiempo (segundos)
- `q_jointX`: Posición articular (radianes)
- `qd_jointX`: Velocidad articular (rad/s)
- `torque_jX`: Torque aplicado (N·m)
- `error_pos`: Error de posición cartesiano (metros)
- `error_vel`: Error de velocidad (m/s)
- `desired_qX`: Posición articular deseada (radianes)

## 🏗️ Arquitectura del Sistema

```
┌─────────────────────────────────────────────────────────────┐
│                    PLANIFICADOR DE TRAYECTORIAS             │
│                     (square_maker.py)                       │
└────────────────────┬────────────────────────────────────────┘
                     │ (Trayectoria deseada X,Y,Z)
                     ▼
┌─────────────────────────────────────────────────────────────┐
│               CINEMÁTICA INVERSA (ik_solver.py)             │
│                  q_deseada = IK(X_deseada)                  │
└────────────────────┬────────────────────────────────────────┘
                     │ (q deseada por articulación)
                     ▼
        ┌────────────────────────────┐
        │    CONTROLADOR (loops)     │
        │   ✓ PID (controller.py)    │
        │   ✓ CTC (controller.py)    │
        └────────┬───────────────────┘
                 │ (Torques calculados τ)
                 ▼
┌─────────────────────────────────────────────────────────────┐
│            SIMULADOR DINÁMICO (dynamics.py)                │
│   q̈ = M(q)^(-1)[τ - C(q,q̇)q̇ - G(q) - f(q̇)]             │
└────────────────────┬────────────────────────────────────────┘
                     │ (q, q̇, q̈ actuales)
                     ▼
┌─────────────────────────────────────────────────────────────┐
│          CINEMÁTICA DIRECTA (kinematics.py)                 │
│              X_actual = FK(q)                               │
└────────────────────┬────────────────────────────────────────┘
                     │
        ┌────────────┴────────────────┐
        ▼                             ▼
┌──────────────────────┐    ┌─────────────────────┐
│  REGISTRADOR         │    │  MONITOR DISTANCIA  │
│ (joint_logger.py)    │    │(distance_monitor.py)│
│  Guarda en CSV       │    │ Calcula métricas    │
└──────────────────────┘    └─────────────────────┘
        │                             │
        └────────────┬────────────────┘
                     │
                     ▼
        ┌────────────────────────────┐
        │  VISUALIZACIÓN Y ANÁLISIS  │
        │  ✓ Python: plot_traj_3d    │
        │  ✓ MATLAB: Diagramas fase  │
        │  ✓ MATLAB: Gráficas        │
        └────────────────────────────┘
```

## 💡 Ejemplos de Uso

### Ejemplo 1: Simulación Completa con PID

```bash
# 1. Generar trayectoria cuadrada
python3 square_maker.py --size 0.5 --time 10 --output square_traj.csv

# 2. Ejecutar controlador PID
python3 controller.py \
    --trajectory square_traj.csv \
    --method PID \
    --Kp 80 --Ki 5 --Kd 40 \
    --output results_pid.csv \
    --verbose

# 3. Visualizar
python3 plot_traj_3d.py --data results_pid.csv --show-error --save-fig pid_results.png

# 4. Analizar en MATLAB
# Abrir MATLAB y ejecutar:
% graficasPID
% diagramasdefasePID
```

### Ejemplo 2: Comparación PID vs CTC

```bash
# Simular con PID
python3 controller.py --traj square_traj.csv --method PID --output results_pid.csv

# Simular con CTC
python3 controller.py --traj square_traj.csv --method CTC --output results_ctc.csv

# Comparar resultados
python3 -c "
import pandas as pd
import matplotlib.pyplot as plt

pid = pd.read_csv('results_pid.csv')
ctc = pd.read_csv('results_ctc.csv')

plt.figure(figsize=(12,6))
plt.subplot(1,2,1)
plt.plot(pid['time'], pid['error_pos'], label='PID')
plt.plot(ctc['time'], ctc['error_pos'], label='CTC')
plt.legend()
plt.ylabel('Error de Posición (m)')

plt.subplot(1,2,2)
plt.plot(pid['time'], [sum(pid.iloc[i, 12:18]**2)**0.5 for i in range(len(pid))], label='PID')
plt.plot(ctc['time'], [sum(ctc.iloc[i, 12:18]**2)**0.5 for i in range(len(ctc))], label='CTC')
plt.legend()
plt.ylabel('Energía Acumulada (J)')
plt.tight_layout()
plt.show()
"
```

### Ejemplo 3: Análisis de Estabilidad

```matlab
% En MATLAB
% Cargar datos
data = readtable('results_pid.csv');

% Análisis de fase
q1 = data.q_joint1;
qd1 = data.qd_joint1;

figure
plot(q1, qd1, 'b-', 'LineWidth', 2)
xlabel('Posición (rad)')
ylabel('Velocidad (rad/s)')
title('Diagrama de Fase - Articulación 1')
grid on

% Calcular índice de estabilidad (si converge a origen)
steady_state_error = mean(abs(q1(end-100:end) - q1(1)));
fprintf('Error en régimen permanente: %.6f rad\n', steady_state_error);
```

## 🔧 Troubleshooting

### Problema: "ModuleNotFoundError: No module named 'numpy'"

**Solución**:
```bash
pip install numpy
# O si usas conda:
conda install numpy
```

### Problema: La trayectoria tiene singularidades

**Síntomas**: Error "Matriz singular detectada" en IK solver

**Soluciones**:
1. Reducir el tamaño de la trayectoria: `--size 0.3` en lugar de 0.5
2. Cambiar puntos iniciales/finales
3. Usar solución numérica iterativa en lugar de analítica
4. Verificar limites articulares

### Problema: Control inestable (oscilaciones)

**Síntomas**: El robot oscila sin converger

**Soluciones**:
1. Reducir ganancia Kp: `--Kp 50` en lugar de 100
2. Aumentar Kd para amortiguamiento
3. Verificar paso de tiempo: `dt < 0.001`
4. Usar controlador CTC (más robusto)

### Problema: MATLAB no carga los datos

**Síntomas**: "Error reading file"

**Soluciones**:
1. Verificar ruta del archivo CSV
2. Asegurar que MATLAB está en la carpeta correcta: `cd '/ruta/al/proyecto'`
3. Verificar formato CSV: columnas separadas por comas
4. Ejecutar: `readtable('archivo.csv')`

### Problema: Visualización 3D no aparece

**Síntomas**: `plot_traj_3d.py` se ejecuta pero sin ventana gráfica

**Soluciones**:
```bash
# Usar backend no interactivo
python3 -c "
import matplotlib
matplotlib.use('TkAgg')  # O 'Qt5Agg', 'Agg', etc.
import matplotlib.pyplot as plt
# resto del código
"

# O agregar al inicio del script:
# import matplotlib; matplotlib.use('TkAgg')
```

### Problema: Archivos CSV muy grandes

**Síntomas**: Ejecución lenta, memoria insuficiente

**Soluciones**:
```python
# Reducir frecuencia de muestreo
--dt 0.01  # en lugar de 0.001

# O procesar en bloques
import pandas as pd
for chunk in pd.read_csv('large_file.csv', chunksize=10000):
    # procesar chunk
```