clear all
clc
%% this script creates a random set of 18 items (one session of critical stimuli)

delimiterIn = ' ';
wordpool = importdata('wordpool.csv', delimiterIn); wordpool = cellstr(split(wordpool, ','));
listlength = 18;
n_session = 4;
stim_cat_all = strings([listlength*n_session,1]);
stim_target_all = strings([listlength*n_session,1]);

%% list 1
L1_pres_cat = strings([listlength,1]);
L1_pres_target = strings([listlength,1]);
L1_pres_pair = strings([listlength,2]);
L1_pres_RP = strings([listlength,1]);
L1_target_first_letter = strings([listlength,1]);

for i = 1:listlength
    while isempty(L1_pres_cat{i,1}) && isempty(L1_pres_target{i,1})
        idx=randperm(length(wordpool),1); %randomly pick a row from the wordpool 
        pick_cat = wordpool{idx,1};
        pick_target = wordpool{idx,2};
        % all 18 items have to be from a different category
        % make sure that no category is repeated 
        if contains(L1_pres_cat,pick_cat) == 0 % make sure that no category is repeated 
            % all of the target words must start with a unique first letter
            % make sure that there's no target word that starts with the same first letter
            if contains(L1_target_first_letter,pick_target(1)) == 0 
                L1_pres_cat{i,1} = pick_cat;
                L1_pres_target{i,1} = pick_target;
            end
        end
    end
    L1_pres_pair{i,1} = L1_pres_cat{i,1};
    L1_pres_pair{i,2} = L1_pres_target{i,1};
    L1_target_first_letter{i,1} = L1_pres_target{i,1}(1);
    stim_target_all{i,1} = L1_pres_target{i,1};
    stim_cat_all{i,1} = L1_pres_cat{i,1};
end

% stim for RP
blank = (' _ ');
for i = 1:listlength
    num_spaces = length(L1_pres_target{i,1})-1; %number of character spaces that need to be masked  
    spaces = repmat({blank},1,num_spaces);
    spaces = string(spaces);
    L1_pres_RP{i,1} = strcat(L1_target_first_letter{i,1},spaces{1:num_spaces});
end

%% list 2
L2_pres_cat = strings([listlength,1]);
L2_pres_target = strings([listlength,1]);

L2_pres_pair = strings([listlength,2]);
L2_pres_RP = strings([listlength,1]);
L2_target_first_letter = strings([listlength,1]);

for i = 1:listlength
    while isempty(L2_pres_cat{i,1}) && isempty(L2_pres_target{i,1})
        idx=randperm(length(wordpool),1); %randomly pick a row from the wordpool 
        pick_cat = wordpool{idx,1};
        pick_target = wordpool{idx,2};
        % all 18 items have to be from a different category
        % make sure that no category is repeated 
        if contains(L2_pres_cat,pick_cat) == 0 % make sure that no category is repeated within session
            % all of the target words must start with a unique first letter
            if contains(stim_target_all,pick_target) == 0 % make sure this target word was not presented during the previous session
            if contains(L2_target_first_letter,pick_target(1)) == 0  % make sure that there's no target word that starts with the same first letter
                L2_pres_cat{i,1} = pick_cat;
                L2_pres_target{i,1} = pick_target;
            end
            end
        end
    end
    L2_pres_pair{i,1} = L2_pres_cat{i,1};
    L2_pres_pair{i,2} = L2_pres_target{i,1};
    L2_target_first_letter{i,1} = L2_pres_target{i,1}(1);
    stim_target_all{i+(listlength*1),1} = L2_pres_target{i,1};
    stim_cat_all{i+(listlength*1),1} = L2_pres_cat{i,1};
end

% stim for RP
blank = (' _ ');
for i = 1:listlength
    num_spaces = length(L2_pres_target{i,1})-1; %number of character spaces that need to be masked  
    spaces = repmat({blank},1,num_spaces);
    spaces = string(spaces);
    L2_pres_RP{i,1} = strcat(L2_target_first_letter{i,1},spaces{1:num_spaces});
end

%% list 3
L3_pres_cat = strings([listlength,1]);
L3_pres_target = strings([listlength,1]);

L3_pres_pair = strings([listlength,2]);
L3_pres_RP = strings([listlength,1]);
L3_target_first_letter = strings([listlength,1]);

for i = 1:listlength
    while isempty(L3_pres_cat{i,1}) && isempty(L3_pres_target{i,1})
        idx=randperm(length(wordpool),1); %randomly pick a row from the wordpool 
        pick_cat = wordpool{idx,1};
        pick_target = wordpool{idx,2};
        % all 18 items have to be from a different category
        % make sure that no category is repeated 
        if contains(L3_pres_cat,pick_cat) == 0 % make sure that no category is repeated within session
            % all of the target words must start with a unique first letter
            if contains(stim_target_all,pick_target) == 0 % make sure this target word was not presented during the previous session
            if contains(L3_target_first_letter,pick_target(1)) == 0  % make sure that there's no target word that starts with the same first letter
                L3_pres_cat{i,1} = pick_cat;
                L3_pres_target{i,1} = pick_target;
            end
            end
        end
    end
    L3_pres_pair{i,1} = L3_pres_cat{i,1};
    L3_pres_pair{i,2} = L3_pres_target{i,1};
    L3_target_first_letter{i,1} = L3_pres_target{i,1}(1);
    stim_target_all{i+(listlength*2),1} = L3_pres_target{i,1};
    stim_cat_all{i+(listlength*2),1} = L3_pres_cat{i,1};
end

% stim for RP
blank = (' _ ');
for i = 1:listlength
    num_spaces = length(L3_pres_target{i,1})-1; %number of character spaces that need to be masked  
    spaces = repmat({blank},1,num_spaces);
    spaces = string(spaces);
    L3_pres_RP{i,1} = strcat(L3_target_first_letter{i,1},spaces{1:num_spaces});
end

%% list 4
L4_pres_cat = strings([listlength,1]);
L4_pres_target = strings([listlength,1]);

L4_pres_pair = strings([listlength,2]);
L4_pres_RP = strings([listlength,1]);
L4_target_first_letter = strings([listlength,1]);

for i = 1:listlength
    while isempty(L4_pres_cat{i,1}) && isempty(L4_pres_target{i,1})
        idx=randperm(length(wordpool),1); %randomly pick a row from the wordpool 
        pick_cat = wordpool{idx,1};
        pick_target = wordpool{idx,2};
        % all 18 items have to be from a different category
        % make sure that no category is repeated 
        if contains(L4_pres_cat,pick_cat) == 0 % make sure that no category is repeated within session
            % all of the target words must start with a unique first letter
            if contains(stim_target_all,pick_target) == 0 % make sure this target word was not presented during the previous session
            if contains(L4_target_first_letter,pick_target(1)) == 0  % make sure that there's no target word that starts with the same first letter
                L4_pres_cat{i,1} = pick_cat;
                L4_pres_target{i,1} = pick_target;
            end
            end
        end
    end
    L4_pres_pair{i,1} = L4_pres_cat{i,1};
    L4_pres_pair{i,2} = L4_pres_target{i,1};
    L4_target_first_letter{i,1} = L4_pres_target{i,1}(1);
    stim_target_all{i+(listlength*3),1} = L4_pres_target{i,1};
    stim_cat_all{i+(listlength*3),1} = L4_pres_cat{i,1};
end

% stim for RP
blank = (' _ ');
for i = 1:listlength
    num_spaces = length(L4_pres_target{i,1})-1; %number of character spaces that need to be masked  
    spaces = repmat({blank},1,num_spaces);
    spaces = string(spaces);
    L4_pres_RP{i,1} = strcat(L4_target_first_letter{i,1},spaces{1:num_spaces});
end
