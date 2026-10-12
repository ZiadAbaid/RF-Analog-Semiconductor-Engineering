% =========================================================================
%  Quantum Mechanical Transmission via Transfer Matrix Method (TMM)
%  Levi – Applied Quantum Mechanics, Exercise 4.4
%
%  Student ID : 61-36390  (xxxx = 6390)
%  m1* = 0.07 + 0.006390 = 0.076390 * m0
%  m2* = 0.14 + 0.006390 = 0.146390 * m0
%
%  Potential inside region [0, L]:
%    Base      : V(x)  = 2 * sin^2( n * 2*pi * x / L )  [eV]
%    Distortion: V'(x) = V0 * ( 1 - ((2x/L) - 1)^2 )   [eV]
%    Total     : Vtot  = V(x) + V'(x)
%
%  Outside [0, L]: V = 0 everywhere.
%  Energy range  : 0.01 eV to 3.0 eV
%  Region width  : L = 20 nm
% =========================================================================
clear; clc; close all;

%% 1. Physical constants
q    = 1.60217663e-19;   % Elementary charge         [C]
m0   = 9.1093837e-31;    % Free electron mass        [kg]
hbar = 1.05457181e-34;   % Reduced Planck constant   [J·s]

%% 2. Spatial grid
L  = 20e-9;              % Width of potential region [m]
N  = 1000;               % Number of spatial slices
dx = L / N;              % Slice width               [m]
x  = linspace(dx/2, L - dx/2, N);   % Midpoints of slices [m]

%% 3. Energy array
E_eV = linspace(0.01, 3.0, 1000);   % Incident energies [eV]

%% 4. Personalised effective masses  (ID: 61-36390)
m1_star = 0.076390;      % First  effective mass ratio  (m1*/m0)
m2_star = 0.146390;      % Second effective mass ratio  (m2*/m0)

%% 5. Define all potentials
% --- Base potentials ---
V_n1 = 2 * sin(1 * 2*pi * x / L).^2;   % n = 1
V_n4 = 2 * sin(4 * 2*pi * x / L).^2;   % n = 4

% --- Parabolic distortion terms ---
xi           = (2*x/L) - 1;             % maps [0,L] -> [-1,+1]
V_prime_01   = 0.1 * (1 - xi.^2);       % V0 = 0.1 eV
V_prime_20   = 2.0 * (1 - xi.^2);       % V0 = 2.0 eV

% --- Distorted total potentials (n = 4 base + parabola) ---
V_distorted_01 = V_n4 + V_prime_01;
V_distorted_20 = V_n4 + V_prime_20;

%% 6. Compute all transmission curves
fprintf('Computing transmission probabilities (TMM) ...\n');

T_n1_m1   = calc_transmission(E_eV, V_n1,          dx, m1_star, m0, hbar, q);
T_n4_m1   = calc_transmission(E_eV, V_n4,          dx, m1_star, m0, hbar, q);
T_n1_m2   = calc_transmission(E_eV, V_n1,          dx, m2_star, m0, hbar, q);
T_n4_m2   = calc_transmission(E_eV, V_n4,          dx, m2_star, m0, hbar, q);
T_dist_01 = calc_transmission(E_eV, V_distorted_01, dx, m1_star, m0, hbar, q);
T_dist_20 = calc_transmission(E_eV, V_distorted_20, dx, m1_star, m0, hbar, q);

fprintf('Done.\n');

%% 7. Plot 1 – Potentials V(x)
figure('Name', 'Potentials V(x)', 'NumberTitle', 'off', ...
       'Position', [100, 100, 960, 640]);

subplot(2,2,1);
plot(x*1e9, V_n1, 'b', 'LineWidth', 1.8);
title('Base potential  (n = 1)');
xlabel('x  (nm)'); ylabel('Energy  (eV)');
xlim([0 20]); ylim([0 2.2]);
grid on; box on;

subplot(2,2,2);
plot(x*1e9, V_n4, 'r', 'LineWidth', 1.8);
title('Base potential  (n = 4)');
xlabel('x  (nm)'); ylabel('Energy  (eV)');
xlim([0 20]); ylim([0 2.2]);
grid on; box on;

subplot(2,2,3);
plot(x*1e9, V_n4,           '--', 'Color', [0.6 0.6 0.6], 'LineWidth', 1.2); hold on;
plot(x*1e9, V_distorted_01, 'k',  'LineWidth', 1.8);
title('Distorted potential  (n = 4,  V_0 = 0.1 eV)');
xlabel('x  (nm)'); ylabel('Energy  (eV)');
legend('Undistorted (n=4)', 'Distorted V_0 = 0.1 eV', 'Location', 'north');
xlim([0 20]); ylim([0 2.5]);
grid on; box on;

subplot(2,2,4);
plot(x*1e9, V_n4,           '--', 'Color', [0.6 0.6 0.6], 'LineWidth', 1.2); hold on;
plot(x*1e9, V_distorted_20, 'm',  'LineWidth', 1.8);
title('Distorted potential  (n = 4,  V_0 = 2.0 eV)');
xlabel('x  (nm)'); ylabel('Energy  (eV)');
legend('Undistorted (n=4)', 'Distorted V_0 = 2.0 eV', 'Location', 'north');
xlim([0 20]); ylim([0 4.5]);
grid on; box on;

sgtitle('Potential profiles  –  L = 20 nm', 'FontSize', 13, 'FontWeight', 'bold');

%% 8. Plot 2 – Transmission vs energy
figure('Name', 'Transmission Probabilities T(E)', 'NumberTitle', 'off', ...
       'Position', [140, 140, 1040, 720]);

% --- (a) n = 1, mass comparison ---
subplot(2,2,1);
plot(E_eV, T_n1_m1, 'b',   'LineWidth', 1.6); hold on;
plot(E_eV, T_n1_m2, 'r--', 'LineWidth', 1.6);
title('T(E)  –  n = 1,  both masses');
xlabel('Incident energy  E  (eV)'); ylabel('Transmission  T');
legend(sprintf('m^* = %.6f m_0', m1_star), ...
       sprintf('m^* = %.6f m_0', m2_star), 'Location', 'northwest');
xlim([0 3]); ylim([0 1.05]);
grid on; box on;

% --- (b) n = 4, mass comparison ---
subplot(2,2,2);
plot(E_eV, T_n4_m1, 'b',   'LineWidth', 1.6); hold on;
plot(E_eV, T_n4_m2, 'r--', 'LineWidth', 1.6);
title('T(E)  –  n = 4,  both masses');
xlabel('Incident energy  E  (eV)'); ylabel('Transmission  T');
legend(sprintf('m^* = %.6f m_0', m1_star), ...
       sprintf('m^* = %.6f m_0', m2_star), 'Location', 'northwest');
xlim([0 3]); ylim([0 1.05]);
grid on; box on;

% --- (c) Weak distortion V0 = 0.1 eV ---
subplot(2,2,3);
plot(E_eV, T_n4_m1,   '-',  'Color', [0.72 0.72 0.72], 'LineWidth', 1.2); hold on;
plot(E_eV, T_dist_01, 'k',  'LineWidth', 1.6);
title('Weak distortion  (n = 4,  V_0 = 0.1 eV,  m_1^*)');
xlabel('Incident energy  E  (eV)'); ylabel('Transmission  T');
legend('Undistorted (n=4)', 'Distorted  V_0 = 0.1 eV', 'Location', 'northwest');
xlim([0 3]); ylim([0 1.05]);
grid on; box on;

% --- (d) Strong distortion V0 = 2.0 eV ---
subplot(2,2,4);
plot(E_eV, T_n4_m1,   '-',  'Color', [0.72 0.72 0.72], 'LineWidth', 1.2); hold on;
plot(E_eV, T_dist_20, 'm',  'LineWidth', 1.6);
title('Strong distortion  (n = 4,  V_0 = 2.0 eV,  m_1^*)');
xlabel('Incident energy  E  (eV)'); ylabel('Transmission  T');
legend('Undistorted (n=4)', 'Distorted  V_0 = 2.0 eV', 'Location', 'northwest');
xlim([0 3]); ylim([0 1.05]);
grid on; box on;

sgtitle('Transmission probability  T(E)  –  L = 20 nm', ...
        'FontSize', 13, 'FontWeight', 'bold');

%% =========================================================================
%  LOCAL FUNCTION – Transfer Matrix Method
%  -------------------------------------------------------------------------
%  Inputs
%    E_eV        : 1-D array of incident energies [eV]
%    V_eV        : 1-D array of potential values  [eV], one per slice
%    dx          : slice width                    [m]
%    m_star_ratio: effective mass as fraction of m0 (dimensionless)
%    m0, hbar, q : physical constants (passed in to keep function self-contained)
%
%  Output
%    T_array     : transmission probability T(E) in [0, 1]
%
%  Algorithm
%    Global transfer matrix  M = S_N * ... * S_2 * S_1  where each S_j is
%    the 2x2 propagation matrix for a slice of constant potential V_j:
%
%      E > V_j  (propagating):
%        S = [  cos(k_j dx),        sin(k_j dx)/k_j ]
%            [ -k_j sin(k_j dx),    cos(k_j dx)     ]
%
%      E < V_j  (evanescent, k_j -> i*kappa_j):
%        S = [  cosh(kappa_j dx),   sinh(kappa_j dx)/kappa_j ]
%            [  kappa_j sinh(...),  cosh(kappa_j dx)          ]
%
%      E = V_j  (degenerate limit):
%        S = [ 1,  dx ]
%            [ 0,   1 ]
%
%    Transmission amplitude from boundary conditions (same k0 on both sides):
%        A  =  0.5 * [ (M22 + M11) + i*(M21/k0 - M12*k0) ]
%        T  =  1 / |A|^2
% =========================================================================
function T_array = calc_transmission(E_eV, V_eV, dx, m_star_ratio, m0, hbar, q)

    m       = m_star_ratio * m0;
    N_slice = length(V_eV);
    V_J     = V_eV * q;                     % Convert potential to Joules
    T_array = zeros(1, length(E_eV));

    for e_idx = 1 : length(E_eV)

        E_J = E_eV(e_idx) * q;
        k0  = sqrt(2 * m * E_J) / hbar;     % Wave vector in free region

        % Initialise global transfer matrix as identity
        M = eye(2);

        for j = 1 : N_slice

            dE = E_J - V_J(j);

            if abs(dE) < 1e-30
                % ---- Degenerate limit  E ≈ V_j -------------------------
                S = [1, dx; 0, 1];

            elseif dE > 0
                % ---- Propagating  (k_j real) ----------------------------
                kj  = sqrt(2 * m * dE) / hbar;
                ckj = cos(kj * dx);
                skj = sin(kj * dx);
                S   = [ ckj,        skj / kj ; ...
                       -kj * skj,   ckj      ];

            else
                % ---- Evanescent  (kappa_j real) -------------------------
                kappa = sqrt(-2 * m * dE) / hbar;
                chk   = cosh(kappa * dx);
                shk   = sinh(kappa * dx);
                S     = [ chk,          shk / kappa ; ...
                          kappa * shk,  chk         ];
            end

            M = S * M;   % Accumulate: M <- S_j * M_{j-1}

        end % slice loop

        % ---- Extract transmission from global matrix -------------------
        %  Boundary conditions give:
        %     t = exp(-i k0 L) / A
        %  with:
        %     A = 0.5 * ( (M11 + M22) + i*(M21/k0 - M12*k0) )
        %  so  T = |t|^2 = 1/|A|^2
        A_real = 0.5 * (M(1,1) + M(2,2));
        A_imag = 0.5 * (M(2,1) / k0  -  M(1,2) * k0);

        T_raw  = 1 / (A_real^2 + A_imag^2);

        % Clamp to [0, 1] to guard against floating-point noise
        T_array(e_idx) = min(1, max(0, T_raw));

    end % energy loop

end