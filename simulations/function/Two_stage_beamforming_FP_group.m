function sum_rate = Two_stage_beamforming_FP_group(G,H,E,tolerance,SNR,Gs)
% github: https://github.com/YijieLinaMao/BD-RIS-low-complexity
%TWO_STAGE_BEAMFORMING_FP_GROUP


Theta=group_symuni(H*G'*E', Gs);
F=G+E'*Theta'*H;

[~,sum_rate]=FP_algorithm_without_noise(F,SNR,tolerance);

end


