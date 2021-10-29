clear;

% Set Directories
healthy_dir = 'C:\Users\ryano\Downloads\H_EMG.xlsx';
drop_dir = 'C:\Users\ryano\Downloads\Drop_Foot_EMG.xlsx';

% Get Sheet Info
[~,h_sheet] = xlsfinfo(healthy_dir);
[~,d_sheet] = xlsfinfo(drop_dir);

% Load Healthy EMG Data
for i = 1:numel(h_sheet)
    h_emg{i} = readmatrix(healthy_dir, 'Sheet', h_sheet{i});
    h_emg{i} = h_emg{i}(:,2:end);
    
    % Max Normalize Data
    for j = 1:size(h_emg{i}, 2)
        norm_h_emg{i}(:,j) = h_emg{i}(:,j) / max(h_emg{i}(:,j));
    end
    
    for j = 1:size(h_emg{i}, 2)
        [h_syn.VAF{i}] = bootci(250, @extract_synergies, norm_h_emg{i}, j);
        % If Lower Bound of .95 CI > 90%
        if(h_syn.VAF{i}(j, 1) > 90)
            [h_syn.weight{i}, h_syn.activ{i}] = nnmf(norm_h_emg{i}, j);
            % Reconstruct New Signal
            h_syn.recon{i} = h_syn.weight{i} * h_syn.activ{i};
            % Force Weights to Add to 1
            for n = 1:size(h_syn.weight{i}, 2)
                h_syn.weight{i}(:,n) = h_syn.weight{i}(:,n)./sum(h_syn.weight{i}(:,n));
            end
            % Synergy Number Found, Exit Loop
            fprintf('Synergies: %d\n', j);
            break;
        end
    end
end

% Load Drop-Foot EMG Data
for i = 1:numel(d_sheet)
    d_emg{i} = readmatrix(drop_dir, 'Sheet', d_sheet{i});
    
    % Max Normalize Data
    for j = 1:size(d_emg{i}, 2)
        norm_d_emg{i}(:,j) = d_emg{i}(:,j) / max(d_emg{i}(:,j));
    end
end

% Perform NNMF and Determine Synergy Number
for m = 1:length(muscle_order)
    % Compute Bootstrap Confidence Interval for NNMF
    VAF.(cur_struct)(m,:) = bootci(250, @extract_synergies, synergies.(hs).(cur_struct), m);
    % If Lower Bound of .95 CI > 90%
    if(VAF.(cur_struct)(m, 1) > 90)
        [weight.(cur_struct), activ.(cur_struct)] = nnmf(synergies.(hs).(cur_struct), m);
        % Reconstruct New Signal
        reconstruct.(cur_struct) = weight.(cur_struct) * activ.(cur_struct);
        % Force Weights to Add to 1
        for n = 1:size(weight.(cur_struct), 2)
            weight.(cur_struct)(:,n) = weight.(cur_struct)(:,n)./sum(weight.(cur_struct)(:,n));
        end
        % Synergy Number Found, Exit Loop
        fprintf('\t%s %s Synergies: %d\n', hs, cur_struct, m);
        break;
    end
end

function [VAF, weight, activ] = extract_synergies(data, m)
    % Perform NNMF with Current Synergy Count
    [weight, activ] = nnmf(data, m);
    % Reconstruct New Signal
    reconstruct = weight * activ;
    
    % Uncentered Pearson Correlation Coefficient
    VAF = 100*(sum(sum(data.*reconstruct,2)) / sqrt((sum(sum(data.^2,2))) * (sum(sum(reconstruct.^2,2)))));
end