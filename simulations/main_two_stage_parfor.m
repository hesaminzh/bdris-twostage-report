% This is a code package related to the following journal paper:
% github: https://github.com/YijieLinaMao/BD-RIS-low-complexity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%T. Fang and Y. Mao, "A Low-Complexity Beamforming Design for Beyond-Diagonal" + ...
%" RIS Aided Multi-User Networks," in IEEE Communications Letters, vol. 28, no. 1,
% pp. 203-207, Jan. 2024, doi: 10.1109/LCOMM.2023.3333411.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% The main two-stage code is written by Tianyu Fang.
% main repo: 
% github: https://github.com/YijieLinaMao/BD-RIS-low-complexity
%
% This version of code implements two-stage algorithm when we don't we have direct link between BS and users
% modified by Hesam Nezhadmohammad
% Date: 14/11/2025
%
%


% addpath('./two_stage_function/')
clc
clear

tolerance=1e-5; %accuracy of convergence


L=4; %number of transmit antennas

K=4; %number of users

Gs = 4; % group size

SNR=20; %transmit SNR

nMonte = 100;
N_RIS_index = 1:5;
N_RIS = 2.^(N_RIS_index+1);
numElements = numel(N_RIS);




data_FC_direct    = zeros(100,5);
data_GC_direct    = zeros(100,5);
data_FC_no_direct = zeros(100,5);
data_GC_no_direct = zeros(100,5);

data_FC_GC_direct_no_direct = nan(nMonte,numElements,4);


% Start parallel pool if not active
if isempty(gcp('nocreate'))
    % parpool('local',2);  % use up to 64 workers if available
    parpool('local', 30);  % use up to 64 workers if available
end
%delete(gcp('nocreate')); % Shut down the parallel pool

parfor iMonte=1:100 % iteration for 100 channel realizations
        data_local = nan(numElements,4);

    for iN=1:length(N_RIS) % iteration for element number from 2^2 to 2^6
  
        disp([iMonte iN]) %output the progress bar
        N=N_RIS(iN);
        [G,H,E]=channel(iMonte,1,K,L,N);
        data_local(iN,1)    = Two_stage_beamforming_FP_fully(G,H,E,tolerance,SNR);
        data_local(iN,2)    = Two_stage_beamforming_FP_group(G,H,E,tolerance,SNR,Gs);
        data_local(iN,3)    = two_stage_FP_no_direct_fully_without_noise(H,E,tolerance,SNR);
        data_local(iN,4)    = two_stage_FP_no_direct_group_without_noise(H,E,Gs,tolerance,SNR);

    end
    data_FC_GC_direct_no_direct(iMonte,:,:) = data_local;

end


figure

T1 = data_FC_GC_direct_no_direct(:,:,1);
T2 = data_FC_GC_direct_no_direct(:,:,2);
T3 = data_FC_GC_direct_no_direct(:,:,3);
T4 = data_FC_GC_direct_no_direct(:,:,4);


x=[4,8,16,32,64];
y1=squeeze(mean(T1,1,'omitnan'));
y2=squeeze(mean(T2,1,'omitnan'));
y3=squeeze(mean(T3,1,'omitnan'));
y4=squeeze(mean(T4,1,'omitnan'));

% save('two_stage_no_direct.mat','x','y1','y2','y3','y4');


slg=semilogx(x,y1,'-o',x,y2,'-d',x,y3,'-o',x,y4,'-d');
slg(1).LineWidth=1.5;
slg(2).LineWidth=1.5;
slg(3).LineWidth=1.5;
slg(4).LineWidth=1.5;

slg(1).Color=color(3);
slg(2).Color=color(3);
slg(3).Color=color(1);
slg(4).Color=color(1);
%

set(gca,'XTick',x,'XTickLabel',[4,8,16,32,64])
xlabel('RIS Elements $N$','interpreter','latex')
ylabel('$f(\mathbf\Theta)$','interpreter','latex')
xlim([4 64])
grid on
set(gca,'xtick',x,'xticklabel',[4,8,16,32,64]);

xlabel('Number of Elements')
ylabel('Sum-Rate (bps/Hz)')

legend({'FC (w/ direct link) [1]', 'GC (w/direct link) [1]', 'FC (w/o direct link)','GC (w/o direct link)'},'Location','northwest');

% print(gcf, 'two_stage.eps', '-depsc2' );
