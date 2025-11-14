function sum_rate = two_stage_FP_no_direct_fully_without_noise(H,E,tolerance,SNR)
% Two-stage beamforming when the direct BS–user channel is absent.
% H : M×K RIS–users channel. (M: # RIS elements; N: # BS antennas; K: # users)
% E : M×N BS–RIS channel.
% modified by Hesam Nezhadmohammad
% Date: 14/11/2025

% Step 1: Form candidate matrix for symmetric unitary projection.
Z = H*H' * E*E';

% Step 2: Apply symmetric unitary projection.
Theta = symuni(Z);

% Step 3: Effective channel (only RIS-assisted path).
F = E' * Theta' * H;

% Step 4: Run fractional programming for sum rate maximisation.
[~, sum_rate] = FP_algorithm_without_noise(F, SNR, tolerance);
end

function out = symuni(A)
% symmetric unitary projection: same as in the original code.
[U, S, V] = svd(A + A.');
R = rank(S);
N = size(A, 1);
U(:, R+1:N) = conj(V(:, R+1:N));
out = U * V';
end

