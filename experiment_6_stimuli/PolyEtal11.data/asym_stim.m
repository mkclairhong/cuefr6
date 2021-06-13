clear all
clc
% this script extracts stimuli set used in Polyn et al.(2011)

load('data_asymFR3.mat')
trial_length = 12;
stim_raw = strings([984*trial_length,2]);
for i = 1:length(data.pres.category) % 633 total encoding trials
    for j = 1:12 % each row contains 24 category-target presentations
        if ~isempty(data.pres.category{i,j})
            category = data.pres.category{i,j};
            target = data.pres_items{i,j};
            
            row = trial_length*(i-1)+j;
            stim_raw{row,1} = category;
            stim_raw{row,2} = target;
        end
    end
end


stim_list_cat = unique(stim_raw(:,1));
stim_list_target = unique(stim_raw(:,2));

% clean the compiled stim list by removing repeated words 
stim_set_final = strings(length(stim_raw),2); %preallocate
for i = 1:length(stim_raw)
   this_targ_word = stim_raw{i,2};
   if strcmp(this_targ_word,stim_set_final) == 0 %if this target word does not exist 
       stim_set_final{i,1} = stim_raw{i,1};
       stim_set_final{i,2} = stim_raw{i,2};
   else
       stim_set_final{i,1} = '';
       stim_set_final{i,2} = '';
   end
end
stim_set_final = stim_set_final(~strcmp(stim_set_final(:,2),''),:); % get rid of all the blanks 
stim_set_final = sortrows(stim_set_final,1); %sort by column 
