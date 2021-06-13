clear all
clc

delimiterIn = ' ';
wordpool = importdata('wordpool.csv', delimiterIn); wordpool = cellstr(split(wordpool, ','));
n_trial = 18;
stim_pick_cat = strings([1,n_trial]);
stim_pick_target = strings([1,n_trial]);
stim_pick_rp = strings([1,n_trial]);
target_first_letter = strings([1,n_trial]);

stim_pick_pair = strings([n_trial,2]);


for i = 1:n_trial
    while isempty(stim_pick_cat{1,i}) && isempty(stim_pick_target{1,i})
        idx=randperm(length(wordpool),1);
        rand_cat = wordpool{idx,1};
        rand_target = wordpool{idx,2};
        if contains(stim_pick_cat,rand_cat) == 0 % there's no duplicate category
            if contains(target_first_letter,rand_target(1)) == 0 % there's no target word that starts with the same first letter
                stim_pick_cat{1,i} = rand_cat;
                stim_pick_target{1,i} = rand_target;
            end
        end
    end
    stim_pick_pair{i,1} = stim_pick_cat{1,i};
    stim_pick_pair{i,2} = stim_pick_target{1,i};
    
    target_first_letter{1,i} = stim_pick_target{1,i}(1);
    
end

% stim for RP
blank = [' _ '];
for i = 1:n_trial
    num_spaces = length(stim_pick_target{1,i})-1; %number of character spaces that need to be masked  
    spaces = repmat({blank},1,num_spaces);
    spaces = string(spaces);
    stim_pick_rp{1,i} = strcat(target_first_letter{1,i},spaces{1:num_spaces});
end

    