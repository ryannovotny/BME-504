clear; close all;
rng(1);

% Set Directories
healthy_dir = 'C:\Users\ryano\Downloads\H_EMG.xlsx';
drop_dir = 'C:\Users\ryano\Downloads\Drop_Foot_EMG.xlsx';

% Get Sheet Info
[~,h_sheet] = xlsfinfo(healthy_dir);
[~,d_sheet] = xlsfinfo(drop_dir);
muscles = {'TFL', 'BIFEMLH', 'PERLONG', 'LATGAS', 'VASLAT', 'TA', 'VASMED', 'RF'};

%% Healthy Participants
% Iterate Through Each Healthy Participant
for i = 1:numel(h_sheet)
    % Read All Columns from Sheet
    h_emg{i} = readmatrix(healthy_dir, 'Sheet', h_sheet{i});
    % Remove Time Column
    h_emg{i} = h_emg{i}(:,2:end);
    
    % Max Normalize Data
    for j = 1:size(h_emg{i}, 2)
        norm_h_emg{i}(:,j) = h_emg{i}(:,j) / max(h_emg{i}(:,j));
    end
    
    % Compute Synergies
    h_syn{i} = confidence(norm_h_emg{i}, 'H', i);
    
    % Compute Residuals
    h_syn{i}.resid = norm_h_emg{i} - h_syn{i}.recon;
end

% Example Results (First Participant)
% Plot Synergies
for k = 1:size(h_syn{1}.weight, 1)
    figure; subplot(2,1,1);
    bar(h_syn{1}.weight(k,:));
    set(gca,'xticklabel',muscles);
    xlabel('Muscles');
    ylabel('Norm. Activation');
    title(['Example Healthy Synergy ' num2str(k)]);
    subplot(2,1,2);
    plot(h_syn{1}.activ(:,k));
    xlabel('% Gait Cycle');
    ylabel('Activation');
    title(['Example Healthy Activation ' num2str(k)]);
end

% Plot Residuals
figure;
plot(h_syn{1}.resid);
xlabel('% Gait Cycle');
ylabel('Activaiton');
title('Residual EMG');

% Plot Original EMG
figure;
plot(norm_h_emg{1});
xlabel('% Gait Cycle');
ylabel('Activaiton');
title('Normalized Original EMG');

% Plot Reconstructed EMG
figure;
plot(h_syn{1}.recon);
xlabel('% Gait Cycle');
ylabel('Activaiton');
title('Reconstructed EMG');

% Plot Scree Plot
screeplot(h_syn{1}.VAF, 'H');

%% Drop-Foot Participants
% Load Drop-Foot EMG Data
for i = 1:numel(d_sheet)
    % Read All Columns from Sheet
    d_emg{i} = readmatrix(drop_dir, 'Sheet', d_sheet{i});
    % Remove Time Column
    d_emg{i} = d_emg{i}(:,2:end);
    
    % Max Normalize Data
    for j = 1:size(d_emg{i}, 2)
        norm_d_emg{i}(:,j) = d_emg{i}(:,j) / max(d_emg{i}(:,j));
    end
    
    % Compute Synergies
    d_syn{i} = confidence(norm_d_emg{i}, 'D', i);
    
    % Compute Residuals
    d_syn{i}.resid = norm_d_emg{i} - d_syn{i}.recon;
end

% Example Results (First Participant)
% Plot Synergies
for k = 1:size(d_syn{1}.weight, 1)
    figure; subplot(2,1,1);
    bar(d_syn{1}.weight(k,:));
    set(gca,'xticklabel',muscles);
    xlabel('Muscles');
    ylabel('Norm. Activation');
    title(['Example Drop-Foot Synergy ' num2str(k)]);
    subplot(2,1,2);
    plot(d_syn{1}.activ(:,k));
    xlabel('% Gait Cycle');
    ylabel('Activation');
    title(['Example Drop-Foot Activation ' num2str(k)]);
end

% Plot Residuals
figure;
plot(d_syn{1}.resid);
xlabel('% Gait Cycle');
ylabel('Activaiton');
title('Residual EMG');

% Plot Original EMG
figure;
plot(norm_d_emg{1});
xlabel('% Gait Cycle');
ylabel('Activaiton');
title('Normalized Original EMG');

% Plot Reconstructed EMG
figure;
plot(d_syn{1}.recon);
xlabel('% Gait Cycle');
ylabel('Activaiton');
title('Reconstructed EMG');

% Plot Scree Plot
screeplot(d_syn{1}.VAF, 'D');

%% Function to Bootstrap Synergy Extraction
function h_syn = confidence(emg, id, i)
    % Compute Synergies
    for j = 1:size(emg, 2)
        % Bootstrap Synergy Extraction and Calculate VAF
        [h_syn.VAF(:,j)] = bootci(250, @extract_synergies, emg, j);
        % If Lower Bound of .95 CI > 90%
        if(j == 2)
            [h_syn.activ, h_syn.weight] = nnmf(emg, j);
            % Reconstruct New Signal
            h_syn.recon = h_syn.activ * h_syn.weight;
            % Force Weights to Add to 1
            for n = 1:size(h_syn.weight, 2)
                h_syn.weight(:,n) = h_syn.weight(:,n)./sum(h_syn.weight(:,n));
            end
            % Synergy Number Found, Exit Loop
            fprintf('%s Participant %d Synergies: %d\n', id, i, j);
            break;
        end
    end
end

%% Function for VAF Calculation
function [VAF, weight, activ] = extract_synergies(data, m)
    % Perform NNMF with Current Synergy Count
    [weight, activ] = nnmf(data, m);
    % Reconstruct New Signal
    reconstruct = weight * activ;
    
    % Uncentered Pearson Correlation Coefficient
    VAF = 100*(sum(sum(data.*reconstruct,2)) / sqrt((sum(sum(data.^2,2))) * (sum(sum(reconstruct.^2,2)))));
end

%% Function to Create Scree Plot
function screeplot(VAF, id)
    % Append 0's to Matrix for Starting Point
    VAF = [0, VAF(1,:);
           0, VAF(2,:)];

    % Scree Plot
    figure;
    plot(VAF(1,:));
    title(id + " VAF");
    xlabel('Synergy Number');
    ylabel('Variance Accounted For');
end