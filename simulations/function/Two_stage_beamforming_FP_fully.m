function sum_rate = Two_stage_beamforming_FP_fully(G,H,E,tolerance,SNR)
% github: https://github.com/YijieLinaMao/BD-RIS-low-complexity
%TWO_STAGE_BEAMFORMING_FP_FULLY 


Theta=symuni(H*G'*E');
F=G+E'*Theta'*H;

[~,sum_rate]=FP_algorithm_without_noise(F,SNR,tolerance);

end


