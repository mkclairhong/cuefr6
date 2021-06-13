clear all
clc
%% this script creates a random set of 18 items (one session of critical stimuli)

delimiterIn = ' ';
wordpool = importdata('wordpool.csv', delimiterIn); wordpool = cellstr(split(wordpool, ','));
n_trial = 18;

%% list 1
pres_cat = strings([n_trial,1]);
pres_target = strings([n_trial,1]);
pres_pair = strings([n_trial,2]);
pres_RP = strings([n_trial,1]);
target_first_letter = strings([n_trial,1]);

for i = 1:n_trial
    while isempty(pres_cat{i,1}) && isempty(pres_target{i,1})
        idx=randperm(length(wordpool),1); %randomly pick a row from the wordpool 
        pick_cat = wordpool{idx,1};
        pick_target = wordpool{idx,2};
        % all 18 items have to be from a different category
        % make sure that no category is repeated 
        if contains(pres_cat,pick_cat) == 0 % make sure that no category is repeated 
            % all of the target words must start with a unique first letter
            % make sure that there's no target word that starts with the same first letter
            if contains(target_first_letter,pick_target(1)) == 0 
                pres_cat{i,1} = pick_cat;
                pres_target{i,1} = pick_target;
            end
        end
    end
    pres_pair{i,1} = pres_cat{i,1};
    pres_pair{i,2} = pres_target{i,1};
    target_first_letter{i,1} = pres_target{i,1}(1);
    
end

% stim for RP
blank = (' _ ');
for i = 1:n_trial
    num_spaces = length(pres_target{i,1})-1; %number of character spaces that need to be masked  
    spaces = repmat({blank},1,num_spaces);
    spaces = string(spaces);
    pres_RP{i,1} = strcat(target_first_letter{i,1},spaces{1:num_spaces});
end
