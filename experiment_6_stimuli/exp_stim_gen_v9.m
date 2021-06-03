clear all
clc

% last update 10/22/2020

%% this script creates stimuli for Experiment 6 
% 25 items in each session, 5 filler + 18 critical items + 2 filler 
% total 4 sessions
% all critical items in one session must start with a unique first letter 

% import the original wordpool
delimiterIn = ' '; 
wordpool = importdata('wordpool.csv', delimiterIn); wordpool = cellstr(split(wordpool, ','));
wordpool_filler = importdata('wordpool_filler.csv', delimiterIn); wordpool_filler = cellstr(split(wordpool_filler, ','));
% specify parameters of the experiment
listlength = 18;
listlength_filler = 7;
LL = listlength + listlength_filler;
n_session = 4;

%% list generation
pres_cat = strings([listlength,n_session]);
pres_target = strings([listlength,n_session]);
pres_rp = strings([listlength,n_session]);
stim_target_first_letter = strings([listlength,n_session]);

stim_cat = strings([listlength,n_session]); 
stim_target = strings([listlength,n_session]);
stim_rp = strings([listlength,n_session]);
% create stim file for subject numbers A to B (results in 'stim_sub_A.csv' to 'stim_sub_B.csv')
for k = 2100:2120
    for i = 1:n_session % each session is saved on different column (1st session = 1st column, 2nd session = 2nd column, etc.)
        for j = 1:listlength
            while isempty(pres_cat{j,i}) && isempty(pres_target{j,i})
                idx=randperm(length(wordpool),1); % randomly pick a row from the wordpool
                pick_cat = wordpool{idx,1}; % categories are in the first column of the wordpool.csv
                pick_target = wordpool{idx,2}; % target words are in the second column of the wordpool.csv
                % all 18 items have to be from a different category
                % make sure that no category is repeated
                if contains(pres_cat(:,i),pick_cat) == 0 % make sure that no category is repeated
                    % all of the target words must start with a unique first letter
                    % make sure that there's no target word that starts with the same first letter
                    if contains(stim_target_first_letter(:,i),pick_target(1)) == 0
                        pres_cat{j,i} = pick_cat;
                        pres_target{j,i} = pick_target;
                    end
                end
            end
            stim_target_first_letter{j,i} = pres_target{j,i}(1);
            stim_target{j,i} = pres_target{j,i};
            stim_cat{j,i} = pres_cat{j,i};
            % create stim for RP
            blank = (' _ ');
            num_spaces = length(pres_target{j,i}) - 1; % number of blanks that participants will see
            spaces = repmat({blank},1,num_spaces);
            spaces = string(spaces);
            pres_rp{j,i} = strcat(stim_target_first_letter{j,i},spaces{1:num_spaces});
            stim_rp{j,i} = pres_rp{j,i};
        end
    end
    % randomize the presentation
    pres_seq = randperm(18)';
    % shuffle all the items (category, target, and RP) in the same random order
    stim_cat = stim_cat(pres_seq,1:4);
    stim_target = stim_target(pres_seq,1:4);
    stim_rp = stim_rp(pres_seq,1:4);
    stim_target_first_letter = stim_target_first_letter(pres_seq,1:4);
    %% crate fillers
    pres_cat_filler = strings([listlength_filler,n_session]);
    pres_target_filler = strings([listlength_filler,n_session]);
    
    filler_cat = strings([listlength_filler,n_session]);
    filler_target = strings([listlength_filler,n_session]);
    filler_target_first_letter = strings([listlength,n_session]);
    filler_rp = strings([listlength_filler,n_session]);
    for i = 1:n_session % each session is saved on different column (1st session = 1st column, 2nd session = 2nd column, etc.)
        for j = 1:listlength_filler
            while isempty(pres_cat_filler{j,i}) && isempty(pres_target_filler{j,i})
                idx=randperm(length(wordpool_filler),1); % randomly pick a row from the wordpool
                pick_cat_filler = wordpool_filler{idx,1}; % categories are in the first column of the wordpool.csv
                pick_target_filler = wordpool_filler{idx,2}; % target words are in the second column of the wordpool.csv
                % all filler items have to be from a different category
                % make sure that no category is repeated
                if contains(pres_cat_filler(:,i),pick_cat_filler) == 0 % make sure that no category is repeated
                    % all of the target words must start with a unique first letter
                    % make sure that there's no target word that starts with the same first letter
                    if contains(stim_target_first_letter(:,i),pick_target_filler(1)) == 0 %make sure no first letter is repeated
                        pres_cat_filler{j,i} = pick_cat_filler;
                        pres_target_filler{j,i} = pick_target_filler;
                    end
                    
                end
            end
            filler_target_first_letter{j,i} = pres_target_filler{j,i}(1);
            % create stim for RP
            blank = (' _ ');
            num_spaces = length(pres_target_filler{j,i}) - 1; % number of blanks that participants will see
            spaces = repmat({blank},1,num_spaces);
            spaces = string(spaces);
            filler_rp{j,i} = strcat(filler_target_first_letter{j,i},spaces{1:num_spaces});
            filler_target{j,i} = pres_target_filler{j,i};
            filler_cat{j,i} = pres_cat_filler{j,i};
        end
    end
    
    
    
    %% compile the items into 25 words in each
    % 1st column = category
    % 2nd column = target
    % 3rd column = first letter
    stimfile = strings([LL*n_session+1,8]);
    headers = {'session', 'category', 'target', 'rp', '', 'critical_cat', 'critical_target', 'critical_rp'};
    sessions = [];
    sessions(1      :LL,1)   = 1;
    sessions(LL+1   :LL*2,1) = 2;
    sessions(LL*2+1 :LL*3,1) = 3;
    sessions(LL*3+1 :LL*4,1) = 4;
    
    LFB = length(filler_cat)-2;% N = 5 Length of the filler at the beginning of each session
    LFE = length(filler_cat)-5;% N = 2 Length of the filler at the end of each session
    LC = length(stim_target); % N = 18 Length of the critical stimuli within each session 
    
    
    for i = 1:n_session
        % 1st column = session number 
        stimfile(1,1) = headers(1);
        stimfile(2:101,1) = sessions; % 1 through 100 because 25 words/session * 4 sessions
        % 2nd column: category
        stimfile(1,2) = headers(2);
        stimfile(LL*(i-1)+2         : LL*(i-1)+LFB+1,2)         = filler_cat(1:5,i); % rows 2 to 6
        stimfile(LL*(i-1)+2+LFB     : LL*(i-1)+LFB+LC+1,2)      = stim_cat(1:18,i);
        stimfile(LL*(i-1)+2+LFB+LC  : LL*(i-1)+LFB+LC+LFE+1,2)  = filler_cat(6:7,i);
        % 3rd column: target
        stimfile(1,3) = headers(3);
        stimfile(LL*(i-1)+2         : LL*(i-1)+LFB+1,3)         = lower(filler_target(1:5,i));
        stimfile(LL*(i-1)+2+LFB     : LL*(i-1)+LFB+LC+1,3)      = lower(stim_target(1:18,i));
        stimfile(LL*(i-1)+2+LFB+LC  : LL*(i-1)+LFB+LC+LFE+1,3)  = lower(filler_target(6:7,i));
        % 4th column: RP
        stimfile(1,4) = headers(4);
        stimfile(LL*(i-1)+2         : LL*(i-1)+LFB+1,4)         = lower(filler_rp(1:5,i));
        stimfile(LL*(i-1)+2+LFB     : LL*(i-1)+LFB+LC+1,4)      = lower(stim_rp(1:18,i));
        stimfile(LL*(i-1)+2+LFB+LC  : LL*(i-1)+LFB+LC+LFE+1,4)  = lower(filler_rp(6:7,i));
        
        % 6th column: critical category
        stimfile(1,6) = headers(6);
        stimfile(LL*(i-1)+2+LFB     : LL*(i-1)+LFB+LC+1,6) = stim_cat(1:18,i);
        
        % 7th column: critical target
        stimfile(1,7) = headers(7);
        stimfile(LL*(i-1)+2+LFB     : LL*(i-1)+LFB+LC+1,7) = lower(stim_target(1:18,i));
        
        % 8th column: critical RP
        stimfile(1,8) = headers(8);
        stimfile(LL*(i-1)+2+LFB     : LL*(i-1)+LFB+LC+1,8) = lower(stim_rp(1:18,i));
    end
    
    stim_export_dir = strcat(pwd,'/stimuli'); 
    subj = num2str(k);
    
    % save as a stim_subj_xx.csv file 
    % (for this to work, you need the cell2csv.m in the folder)
    cell2csv([stim_export_dir 'stim_subj_' subj '.csv'], stimfile);
    output_name = sprintf([pwd,'/stimuli/','stim_subj_%d'],k);
    
    % save as a .mat file
    save(output_name, 'stimfile');
end

