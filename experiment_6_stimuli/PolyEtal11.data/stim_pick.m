clear all
clc

delimiterIn = ' ';
wordpool = importdata('wordpool.csv', delimiterIn); wordpool = cellstr(split(wordpool, ','));
stim_pick_cat = strings([1,18]);
stim_pick_target = strings([1,18]);
target_first_letter = strings([1,18]);
stim_pick_pair = strings([18,2]);



% for i = 1:18
%     while isempty(stim_pick_cat{1,i})
%         idx=randperm(length(wordpool),1);
%         rand_cat = wordpool{idx};
%         rand_target = wordpool{idx,2};
%         if contains(stim_pick_cat,rand_cat) == 0 % to make sure no category is repeated 
%             stim_pick_cat{1,i} = rand_cat;
%             stim_pick_target{1,i} = rand_target;
%         end
%     end
%     stim_pick_pair{i,1} = stim_pick_cat{1,i};
%     stim_pick_pair{i,2} = stim_pick_target{1,i};
% end

% for i = 1:18
%     while isempty(stim_pick_cat{1,i}) && isempty(stim_pick_target{1,i})
%         idx=randperm(length(wordpool),1);
%         rand_cat = wordpool{idx};
%         rand_target = wordpool{idx,2};
%         if contains(stim_pick_cat,rand_cat) == 0 % to make sure no category is repeated
%             stim_pick_cat{1,i} = rand_cat;
%             if contains(stim_pick_target,rand_target(1)) == 0 % make sure that no two words start with the same character
%                 stim_pick_target{1,i} = rand_target;
%             end
%         end
%     end
%     stim_pick_pair{i,1} = stim_pick_cat{1,i};
%     stim_pick_pair{i,2} = stim_pick_target{1,i};
% end

% for i = 1:18
%     while isempty(stim_pick_cat{1,i}) && isempty(stim_pick_target{1,i})
%         idx=randperm(length(wordpool),1);
%         rand_cat = wordpool{idx};
%         rand_target = wordpool{idx,2};
%        
%         if contains(target_first_letter,rand_target(1)) == 0 % make sure that no two words start with the same character
%             stim_pick_target{1,i} = rand_target;
%             
%             if contains(stim_pick_cat,rand_cat) == 0 % to make sure no category is repeated
%                 stim_pick_cat{1,i} = rand_cat;
%             end
%         end
%     end
%     stim_pick_pair{i,1} = stim_pick_cat{1,i};
%     stim_pick_pair{i,2} = stim_pick_target{1,i};
%     target_first_letter{1,i} = stim_pick_target{1,i};
% end

% for i = 1:18
%     while isempty(stim_pick_cat{1,i}) && isempty(stim_pick_target{1,i})
%         idx=randperm(length(wordpool),1);
%         rand_cat = wordpool{idx};
%         rand_target = wordpool{idx,2};
%         if contains(stim_pick_cat,rand_cat) == 0 % to make sure no category is repeated
%             stim_pick_cat{1,i} = rand_cat;
%             
%             if contains(target_first_letter,rand_target(1)) == 0 % make sure that no two words start with the same character
%                 stim_pick_target{1,i} = rand_target;
%                 
%             end
%         end
%     end
%     stim_pick_pair{i,1} = stim_pick_cat{1,i};
%     stim_pick_pair{i,2} = stim_pick_target{1,i};
%     target_first_letter{1,i} = stim_pick_target{1,i};
% end
% for i = 1:18
%     while isempty(stim_pick_cat{1,i}) && isempty(stim_pick_target{1,i})
%         idx=randperm(length(wordpool),1);
%         rand_cat = wordpool{idx};
%         rand_target = wordpool{idx,2};
%         if contains(target_first_letter,rand_target(1)) == 0 % make sure that no two words start with the same character
%             stim_pick_target{1,i} = rand_target;
%             
%             if contains(stim_pick_cat,rand_cat) == 0 % to make sure no category is repeated
%                 stim_pick_cat{1,i} = rand_cat;
%             end
%             
%         end
%     end
%     stim_pick_pair{i,1} = stim_pick_cat{1,i};
%     stim_pick_pair{i,2} = stim_pick_target{1,i};
%     target_first_letter{1,i} = stim_pick_target{1,i};
% end

for i = 1:18
    while isempty(stim_pick_cat{1,i}) && isempty(stim_pick_target{1,i})
        idx=randperm(length(wordpool),1);
        rand_cat = wordpool{idx,1};
        rand_target = wordpool{idx,2};
        if contains(stim_pick_cat,rand_cat) == 0 
            if contains(target_first_letter,rand_target(1)) == 0
                stim_pick_cat{1,i} = rand_cat;
                stim_pick_target{1,i} = rand_target;
            end
        end
    end
    stim_pick_pair{i,1} = stim_pick_cat{1,i};
    stim_pick_pair{i,2} = stim_pick_target{1,i};
    target_first_letter{1,i} = stim_pick_target{1,i}(1);
end




        