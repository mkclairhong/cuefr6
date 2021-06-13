clear all
clc
%% this script creates a random set of 18 items (one session of critical stimuli)

% import the original wordpool 
delimiterIn = ' '; wordpool = importdata('wordpool.csv', delimiterIn); wordpool = cellstr(split(wordpool, ','));

% specify parameters of the experiment 
listlength = 18;
n_session = 4;
stim_cat_all = strings([listlength*n_session,1]); % all of the category words in onc place 
stim_target_all = strings([listlength*n_session,1]); % all of the target words in onc place 
stim_rp_all = strings([listlength*n_session,1]);

%% list generation 
pres_cat = strings([listlength,n_session]);
pres_target = strings([listlength,n_session]);
%pres_pair = strings([listlength,2]);
pres_rp = strings([listlength,1]);
target_first_letter = strings([listlength,1]);

for i = 1:n_session % each session is saved on different column (1st session = 1st column, 2nd session = 2nd column, etc.)
    for j = 1:listlength
        while isempty(pres_cat{j,i}) && isempty(pres_target{j,i})
            idx=randperm(length(wordpool),1); % randomly pick a row from the wordpool
            pick_cat = wordpool{idx,1}; % categories are in the first column of the wordpool.csv
            pick_target = wordpool{idx,2}; % target words are in the second column of the wordpool.csv
            % all 18 items have to be from a different category
            % make sure that no category is repeated
            if contains(pres_cat,pick_cat) == 0 % make sure that no category is repeated
                % all of the target words must start with a unique first letter
                % make sure that there's no target word that starts with the same first letter
                if contains(target_first_letter,pick_target(1)) == 0
                    pres_cat{j,i} = pick_cat;
                    pres_target{j,i} = pick_target;
                end
            end
        end
        %pres_pair{j,1} = pres_cat{j,i};
        %pres_pair{j,2} = pres_target{j,i};
        target_first_letter{i,1} = pres_target{j,i}(1);
        stim_target_all{listlength*(i-1)+j,1}= pres_target{j,i}; %compile all the targets in one row 
        stim_cat_all{listlength*(i-1)+j,1} = pres_cat{j,i};
        
        % create stim for RP
        blank = (' _ ');
        num_spaces = length(pres_target{j,i}) - 1;
        spaces = repmat({blank},1,num_spaces);
        spaces = string(spaces);
        pres_rp{j,i} = strcat(target_first_letter{j,i},spaces{1:num_spaces});
        stim_rp_all{listlength*(i-1)+j,1} = pres_rp{j,i};
    end
end


