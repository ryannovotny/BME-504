clear;

directory = 'E:\Users\ryano\Desktop\USC\Research\Projects\ProcessEMG\Balance Study\Perturbations\';

% Get All Folders In Directory
all_folders = dir(directory);
all_folders = all_folders([all_folders(:).isdir]);
all_folders = all_folders(3:end);

for sub_idx = 1:length(all_folders)
    %% Determine Files To Process
    % Get Participant Subdirectory
    current_subject = all_folders(sub_idx).name;
    disp(['<strong>***** PARTICIPANT: ', current_subject, ' *****</strong>']);
    cur_direct = [directory current_subject '\'];
    % Get All .mat Files
    res_files = dir([cur_direct '/result*.mat']);
    
    % Loop Through Results Files
    for res_idx = 1:length(res_files)
        cd(cur_direct);
        % Load First Result File
        disp(['<strong>***** FILE: ', res_files(res_idx).name, ' *****</strong>']);
        part_data = load([cur_direct res_files(res_idx).name]);
        
        % Copy Paretic EMG Ensemble
        s_emg{sub_idx}.P_HS{res_idx}.baseline = part_data.synergies.P_HS.baseline;
        s_emg{sub_idx}.P_HS{res_idx}.perturb = part_data.synergies.P_HS.perturb;
        s_emg{sub_idx}.P_HS{res_idx}.first_rec = part_data.synergies.P_HS.first_rec;
        s_emg{sub_idx}.P_HS{res_idx}.second_rec = part_data.synergies.P_HS.second_rec;
        s_emg{sub_idx}.P_HS{res_idx}.third_rec = part_data.synergies.P_HS.third_rec;
        s_emg{sub_idx}.P_HS{res_idx}.fourth_rec = part_data.synergies.P_HS.fourth_rec;
        
        % Copy Paretic Synergies
        s_syn{sub_idx}.P_HS{res_idx}.weight = part_data.synergies.P_HS.weight;
        s_syn{sub_idx}.P_HS{res_idx}.activ = part_data.synergies.P_HS.activ;
        %s_syn{sub_idx}.P_HS{res_idx}.recon = part_data.synergies.P_HS.reconstruct;
        s_syn{sub_idx}.P_HS{res_idx}.VAF = part_data.synergies.P_HS.VAF;
        
        % Generate Reconstructed Signals Using Only 2 Modules
        s_syn{sub_idx}.P_HS{res_idx}.recon.baseline = s_syn{sub_idx}.P_HS{res_idx}.weight.baseline(:,1:2) * s_syn{sub_idx}.P_HS{res_idx}.activ.baseline(1:2,:);
        s_syn{sub_idx}.P_HS{res_idx}.recon.perturb = s_syn{sub_idx}.P_HS{res_idx}.weight.perturb(:,1:2) * s_syn{sub_idx}.P_HS{res_idx}.activ.perturb(1:2,:);
        s_syn{sub_idx}.P_HS{res_idx}.recon.first_rec = s_syn{sub_idx}.P_HS{res_idx}.weight.first_rec(:,1:2) * s_syn{sub_idx}.P_HS{res_idx}.activ.first_rec(1:2,:);
        s_syn{sub_idx}.P_HS{res_idx}.recon.second_rec = s_syn{sub_idx}.P_HS{res_idx}.weight.second_rec(:,1:2) * s_syn{sub_idx}.P_HS{res_idx}.activ.second_rec(1:2,:);
        s_syn{sub_idx}.P_HS{res_idx}.recon.third_rec = s_syn{sub_idx}.P_HS{res_idx}.weight.third_rec(:,1:2) * s_syn{sub_idx}.P_HS{res_idx}.activ.third_rec(1:2,:);
        s_syn{sub_idx}.P_HS{res_idx}.recon.fourth_rec = s_syn{sub_idx}.P_HS{res_idx}.weight.fourth_rec(:,1:2) * s_syn{sub_idx}.P_HS{res_idx}.activ.fourth_rec(1:2,:);
        
        % Generate Paretic Residuals
        s_syn{sub_idx}.P_HS{res_idx}.resid.baseline = s_emg{sub_idx}.P_HS{res_idx}.baseline - s_syn{sub_idx}.P_HS{res_idx}.recon.baseline;
        s_syn{sub_idx}.P_HS{res_idx}.resid.perturb = s_emg{sub_idx}.P_HS{res_idx}.perturb - s_syn{sub_idx}.P_HS{res_idx}.recon.perturb;
        s_syn{sub_idx}.P_HS{res_idx}.resid.first_rec = s_emg{sub_idx}.P_HS{res_idx}.first_rec - s_syn{sub_idx}.P_HS{res_idx}.recon.first_rec;
        s_syn{sub_idx}.P_HS{res_idx}.resid.second_rec = s_emg{sub_idx}.P_HS{res_idx}.second_rec - s_syn{sub_idx}.P_HS{res_idx}.recon.second_rec;
        s_syn{sub_idx}.P_HS{res_idx}.resid.third_rec = s_emg{sub_idx}.P_HS{res_idx}.third_rec - s_syn{sub_idx}.P_HS{res_idx}.recon.third_rec;
        s_syn{sub_idx}.P_HS{res_idx}.resid.fourth_rec = s_emg{sub_idx}.P_HS{res_idx}.fourth_rec - s_syn{sub_idx}.P_HS{res_idx}.recon.fourth_rec;
        
        % Copy Non-Paretic EMG Ensemble
        s_emg{sub_idx}.NP_HS{res_idx}.baseline = part_data.synergies.NP_HS.baseline;
        s_emg{sub_idx}.NP_HS{res_idx}.perturb = part_data.synergies.NP_HS.perturb;
        s_emg{sub_idx}.NP_HS{res_idx}.first_rec = part_data.synergies.NP_HS.first_rec;
        s_emg{sub_idx}.NP_HS{res_idx}.second_rec = part_data.synergies.NP_HS.second_rec;
        s_emg{sub_idx}.NP_HS{res_idx}.third_rec = part_data.synergies.NP_HS.third_rec;
        s_emg{sub_idx}.NP_HS{res_idx}.fourth_rec = part_data.synergies.NP_HS.fourth_rec;
        
        % Copy Non-Paretic Synergies
        s_syn{sub_idx}.NP_HS{res_idx}.weight = part_data.synergies.NP_HS.weight;
        s_syn{sub_idx}.NP_HS{res_idx}.activ = part_data.synergies.NP_HS.activ;
        %s_syn{sub_idx}.NP_HS{res_idx}.recon = part_data.synergies.NP_HS.reconstruct;
        s_syn{sub_idx}.NP_HS{res_idx}.VAF = part_data.synergies.NP_HS.VAF;
        
        % Generate Reconstructed Signals Using Only 2 Modules
        s_syn{sub_idx}.NP_HS{res_idx}.recon.baseline = s_syn{sub_idx}.NP_HS{res_idx}.weight.baseline(:,1:2) * s_syn{sub_idx}.NP_HS{res_idx}.activ.baseline(1:2,:);
        s_syn{sub_idx}.NP_HS{res_idx}.recon.perturb = s_syn{sub_idx}.NP_HS{res_idx}.weight.perturb(:,1:2) * s_syn{sub_idx}.NP_HS{res_idx}.activ.perturb(1:2,:);
        s_syn{sub_idx}.NP_HS{res_idx}.recon.first_rec = s_syn{sub_idx}.NP_HS{res_idx}.weight.first_rec(:,1:2) * s_syn{sub_idx}.NP_HS{res_idx}.activ.first_rec(1:2,:);
        s_syn{sub_idx}.NP_HS{res_idx}.recon.second_rec = s_syn{sub_idx}.NP_HS{res_idx}.weight.second_rec(:,1:2) * s_syn{sub_idx}.NP_HS{res_idx}.activ.second_rec(1:2,:);
        s_syn{sub_idx}.NP_HS{res_idx}.recon.third_rec = s_syn{sub_idx}.NP_HS{res_idx}.weight.third_rec(:,1:2) * s_syn{sub_idx}.NP_HS{res_idx}.activ.third_rec(1:2,:);
        s_syn{sub_idx}.NP_HS{res_idx}.recon.fourth_rec = s_syn{sub_idx}.NP_HS{res_idx}.weight.fourth_rec(:,1:2) * s_syn{sub_idx}.NP_HS{res_idx}.activ.fourth_rec(1:2,:);
        
        % Generate Non-Paretic Residuals
        s_syn{sub_idx}.NP_HS{res_idx}.resid.baseline = s_emg{sub_idx}.NP_HS{res_idx}.baseline - s_syn{sub_idx}.NP_HS{res_idx}.recon.baseline;
        s_syn{sub_idx}.NP_HS{res_idx}.resid.perturb = s_emg{sub_idx}.NP_HS{res_idx}.perturb - s_syn{sub_idx}.NP_HS{res_idx}.recon.perturb;
        s_syn{sub_idx}.NP_HS{res_idx}.resid.first_rec = s_emg{sub_idx}.NP_HS{res_idx}.first_rec - s_syn{sub_idx}.NP_HS{res_idx}.recon.first_rec;
        s_syn{sub_idx}.NP_HS{res_idx}.resid.second_rec = s_emg{sub_idx}.NP_HS{res_idx}.second_rec - s_syn{sub_idx}.NP_HS{res_idx}.recon.second_rec;
        s_syn{sub_idx}.NP_HS{res_idx}.resid.third_rec = s_emg{sub_idx}.NP_HS{res_idx}.third_rec - s_syn{sub_idx}.NP_HS{res_idx}.recon.third_rec;
        s_syn{sub_idx}.NP_HS{res_idx}.resid.fourth_rec = s_emg{sub_idx}.NP_HS{res_idx}.fourth_rec - s_syn{sub_idx}.NP_HS{res_idx}.recon.fourth_rec;
        
        % Copy Muscle Order
        s_emg{sub_idx}.muscle_order{res_idx} = part_data.muscle_order;
        s_syn{sub_idx}.muscle_order{res_idx} = part_data.muscle_order;
    end
end

% Save File
save_dir = 'E:\Users\ryano\Desktop\Resids\';
filename = 'resid_2_PC.mat';
cd(save_dir);
save(filename, 's_emg', 's_syn');