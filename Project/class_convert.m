clear;

directory = 'C:\Users\rnovotny\Desktop\Parts\';

% Get All Folders In Directory
all_folders = dir(directory);
all_folders = all_folders([all_folders(:).isdir]);

for sub_idx = 3:length(all_folders)
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
        s_emg.P_HS.baseline = part_data.synergies.P_HS.baseline;
        s_emg.P_HS.perturb = part_data.synergies.P_HS.perturb;
        s_emg.P_HS.first_rec = part_data.synergies.P_HS.first_rec;
        s_emg.P_HS.second_rec = part_data.synergies.P_HS.second_rec;
        s_emg.P_HS.third_rec = part_data.synergies.P_HS.third_rec;
        s_emg.P_HS.fourth_rec = part_data.synergies.P_HS.fourth_rec;
        
        % Copy Paretic Synergies
        s_syn.P_HS.weight = part_data.synergies.P_HS.weight;
        s_syn.P_HS.activ = part_data.synergies.P_HS.activ;
        s_syn.P_HS.recon = part_data.synergies.P_HS.reconstruct;
        s_syn.P_HS.VAF = part_data.synergies.P_HS.VAF;
        
        % Generate Paretic Residuals
        s_syn.P_HS.resid.baseline = s_emg.P_HS.baseline - s_syn.P_HS.recon.baseline;
        s_syn.P_HS.resid.perturb = s_emg.P_HS.perturb - s_syn.P_HS.recon.perturb;
        s_syn.P_HS.resid.first_rec = s_emg.P_HS.first_rec - s_syn.P_HS.recon.first_rec;
        s_syn.P_HS.resid.second_rec = s_emg.P_HS.second_rec - s_syn.P_HS.recon.second_rec;
        s_syn.P_HS.resid.third_rec = s_emg.P_HS.third_rec - s_syn.P_HS.recon.third_rec;
        s_syn.P_HS.resid.fourth_rec = s_emg.P_HS.fourth_rec - s_syn.P_HS.recon.fourth_rec;
        
        % Copy Non-Paretic EMG Ensemble
        s_emg.NP_HS.baseline = part_data.synergies.NP_HS.baseline;
        s_emg.NP_HS.perturb = part_data.synergies.NP_HS.perturb;
        s_emg.NP_HS.first_rec = part_data.synergies.NP_HS.first_rec;
        s_emg.NP_HS.second_rec = part_data.synergies.NP_HS.second_rec;
        s_emg.NP_HS.third_rec = part_data.synergies.NP_HS.third_rec;
        s_emg.NP_HS.fourth_rec = part_data.synergies.NP_HS.fourth_rec;
        
        % Copy Non-Paretic Synergies
        s_syn.NP_HS.weight = part_data.synergies.NP_HS.weight;
        s_syn.NP_HS.activ = part_data.synergies.NP_HS.activ;
        s_syn.NP_HS.recon = part_data.synergies.NP_HS.reconstruct;
        s_syn.NP_HS.VAF = part_data.synergies.NP_HS.VAF;
        
        % Generate Non-Paretic Residuals
        s_syn.NP_HS.resid.baseline = s_emg.NP_HS.baseline - s_syn.NP_HS.recon.baseline;
        s_syn.NP_HS.resid.perturb = s_emg.NP_HS.perturb - s_syn.NP_HS.recon.perturb;
        s_syn.NP_HS.resid.first_rec = s_emg.NP_HS.first_rec - s_syn.NP_HS.recon.first_rec;
        s_syn.NP_HS.resid.second_rec = s_emg.NP_HS.second_rec - s_syn.NP_HS.recon.second_rec;
        s_syn.NP_HS.resid.third_rec = s_emg.NP_HS.third_rec - s_syn.NP_HS.recon.third_rec;
        s_syn.NP_HS.resid.fourth_rec = s_emg.NP_HS.fourth_rec - s_syn.NP_HS.recon.fourth_rec;
        
        % Save New File
        muscle_order = part_data.muscle_order;
        save_dir = ['C:\Users\rnovotny\Desktop\Resids\' current_subject];
        if(~exist(save_dir, 'dir'))
            mkdir(save_dir);
        end
        filename = ['resid' char(regexp(res_files(1).name, '\d+', 'match')) '.mat'];
        cd(save_dir);
        save(filename, 's_emg', 's_syn', 'muscle_order');
    end
end