% last edited 05/06/2020

% EXCLUEDE participant 1112 only has two session worth of data 
% there's no subj 1119 so the subject #1100's csv file was renamed to 1119
n_sub = 33;

for i = 1101:1133
    filename = sprintf('data/exp_RW6_data_subj_%d.csv',i);
    delimiterIn = ' ';
    subj{i} = importdata(filename,delimiterIn); %import the recall data for list(i) including blank spaces (delimiterIn)
    rec = cellstr(split(subj{i}, ',')); %split the imported file so words are in separate cells; this "data" then contains the list's recall responses
    k = i-1100;
    output_name = sprintf('subj%d',k); %what the output is named 
    save(output_name,'rec');
end

recall_itemnos_session{1} = NaN(n_sub,100);
recall_itemnos_session{2} = NaN(n_sub,100);
recall_itemnos_session{3} = NaN(n_sub,100);
recall_itemnos_session{4} = NaN(n_sub,100);
recall_itemnos = NaN(n_sub*4,100);

rp_itemnos_session{1} = NaN(n_sub,3);
rp_itemnos_session{2} = NaN(n_sub,3);
rp_itemnos_session{3} = NaN(n_sub,3);
rp_itemnos_session{4} = NaN(n_sub,3);
rp_itemnos = NaN(n_sub*4,3);

summary =  NaN(n_sub*4,14);

for i = 1:n_sub
    rec_file = sprintf('subj%d.mat',i);
    tmp = load(rec_file);
    subj_data = tmp.rec;
    
    for k = 1:4
        n_session = num2str(k);
        session_mask = strcmp(subj_data(:,1),n_session); % extract session "k"
        session = subj_data(session_mask,:);
        
        wordpool_mask = strcmp(session(:,4), 'study');
        wordpool = session(wordpool_mask,:);
        wordpool = wordpool(:,5);
        session_rp_mask = strcmp(session(:,4),'rp');
        session_rp = session(session_rp_mask,:);
        session_rec_mask = strcmp(session(:,4),'recall'); % extract just the recalls
        session_recall = session(session_rec_mask,:);
        
        % retrieval practice 
        for l = 1:3
            if ~isempty(session_rp)
                this_rp = session_rp{l,6};
                wordpool_rp = [wordpool(7) wordpool(13) wordpool(19)]; %7th, 13th, and 19th are critical items
                match = strcmp(this_rp,wordpool_rp);
                ind_rp = find(match);
                
                if ~isempty(ind_rp)
                    rp_itemnos_session{k}(i,l) = ind_rp*6+1;
                else
                    rp_itemnos_session{k}(i,l) = 0;
                end
            end
        end
        rp_itemnos((i-1)*4+k,:) = rp_itemnos_session{k}(i,:); %compile all to one 
        
        % recall 
        for j = 1:size(session_recall,1)
            if ~isempty(session_recall) %recalled item
                this_word = session_recall{j,6};
                match = strcmp(this_word,wordpool);
                this_ind = find(match,1); %some fillers have double matches (repeated), so just use the first match
                
                if ~isempty(this_ind)
                    recall_itemnos_session{k}(i,j) = this_ind;
                else
                    recall_itemnos_session{k}(i,j) = 0;
                end
            end
        end
        recall_itemnos((i-1)*4+k,:) = recall_itemnos_session{k}(i,:); %compile all to one
        
        if i ~= 12            
            summary((i-1)*4+k,1) = i; % subj number
            summary((i-1)*4+k,2) = k; % session
            summary((i-1)*4+k,3) =str2double(session(1,3)); % condition 
        end
        
    end
end
summary_header= [];
summary_header{1} = 'subjects';
summary_header{2} = 'session';
summary_header{3} = 'condition';

% use recall itemnos uncleaned with NaN's for spc & crp 
recall_itemnos_spc = recall_itemnos;
recall_itemnos_crp = recall_itemnos; 

% remove repeats for performance scoring 
recall_itemnos = clean_recalls(recall_itemnos); % remove repeats 
%% Performance 

% rp success & recall scoring 
% recalls are valid only when it's the critical items (items 6 ~ 23 in the
% study list)

rp_itemnos_score = NaN(n_sub*4,3);
for i = 1:n_sub*4
    for j = 1:3
        if ~isnan(rp_itemnos(i,j))
            if rp_itemnos(i,j) > 0
                rp_itemnos_score(i,j) = 1;
            else
                rp_itemnos_score(i,j) = 0;
            end
        end
    end
    summary(i,4) = nansum(rp_itemnos_score(i,:))/3; % rp success 
end
summary_header{4} = 'retrieval practice success';

recall_itemnos_score = NaN(n_sub*4,100);
recall_critical = NaN(n_sub*4,100);
recall_critical_backward = NaN(n_sub*4,100);
recall_critical_forward = NaN(n_sub*4,100);
for i = 1:n_sub*4
    for j = 1:100
        if recall_itemnos(i,j) > 5 && recall_itemnos(i,j) < 24 %critical items are items 6 ~ 23
            recall_itemnos_score(i,j) = 1;
        else
            recall_itemnos_score(i,j) = 0;
        end
        
        if (recall_itemnos(i,j)==7 || recall_itemnos(i,j)==13 || recall_itemnos(i,j)==19)
            recall_critical(i,j) = 1;
        else
            recall_critical(i,j) = 0;
        end
        
        if (recall_itemnos(i,j)==6 || recall_itemnos(i,j)==12 || recall_itemnos(i,j)==18)
            recall_critical_backward(i,j) = 1;
        else
            recall_critical_backward(i,j) = 0;
        end
        
        if (recall_itemnos(i,j)==8 || recall_itemnos(i,j)==14 || recall_itemnos(i,j)==20)
            recall_critical_forward(i,j) = 1;
        else
            recall_critical_forward(i,j) = 0;
        end
    end
    summary(i,5) = sum(recall_itemnos_score(i,:))/18; % overall recall %
    summary(i,6) = sum(recall_critical(i,:))/3; % critical items recall %
    summary(i,7) = sum(recall_critical_backward(i,:))/3; % -1 items recalled
    summary(i,8) = sum(recall_critical_forward(i,:))/3; % +1 items recalled
    summary(i,9) = (sum(recall_critical_backward(i,:))+sum(recall_critical_forward(i,:)))/6; % temporal neighbors in general 
end
summary_header{5} = 'recall_overall';
summary_header{6} = 'recall_critical';
summary_header{7} = 'recall_(-1)neighbors';
summary_header{8} = 'recall_(+1)neighbors';
summary_header{9} = 'recall_neighbors';

% %% conditional recall probability:
% compare recall probabilities for critical items and thier -1 and + 1 neighbors. 

% Using "Yoked-pair" analysis here treat the Retrieval Practice and Control
% sessions as "yoked pairs" (e.g., if participant 1 successfully
% retreival-practiced trials 7 and 13 in one of the blocks you would
% compare their free recall of items 8 and 14 to their free recall of items
% 8 and 14 in the corresponding restudy block. Then collapse over block to
% have just one rp and rs value for each participant).

% rationale:  if a participant has no retrieval practice success in one of
% the two sessions and if we use that mean, it's the same as weighting that
% single rp-success session twice (vs. for control, there's two sessions
% worth of data)
 
% yoked_conditional_recall_critical = NaN(n_sub*4,100);
% yoked_rp_backward = NaN(n_sub*4,100); yoked_rp_forward =
% NaN(n_sub*4,100); critical = [7, 13, 19]; for i = 1:n_sub*4
%     for j = 1:100
%         if ~isnan(rp_itemnos(i,:))
%             
%             for k = 1:3
%                 item = critical(k);
%                 
%                 % critical items (7, 13, 19)
%                 if any(rp_itemnos(i,:)==item)
%                     if (recall_itemnos(i,j)==item)
%                         yoked_conditional_recall_critical(i,j) = recall_critical(i,j);
%                     end
%                 end
%                 % -1 temporal contiguous items (6,12,18)
%                 if any(rp_itemnos(i,:)== (item))
%                     if (recall_itemnos(i,j)== (item-1))
%                         yoked_rp_backward(i,j) = recall_critical_backward(i,j);
%                     end
%                 end
%                 % +1 temporal contiguous items (8,14,20)
%                 if any(rp_itemnos(i,:)== (item))
%                     if (recall_itemnos(i,j)== (item+1))
%                         yoked_rp_forward(i,j) = recall_critical_forward(i,j);
%                     end
%                 end
%             end
%             summary(i,12) = nansum(yoked_conditional_recall_critical(i,:))/sum(rp_itemnos_score(i,:)); % conditional: critical items recall %
%             summary(i,13) = nansum(yoked_rp_backward(i,:))/sum(rp_itemnos_score(i,:)); % conditional: -1 items recalled
%             summary(i,14) = nansum(yoked_rp_forward(i,:))/sum(rp_itemnos_score(i,:)); % conditional: +1 items recalled
%             
%         end
%     end
% end
% 
% summary_header{12} = 'conditional_recall_critical';
% summary_header{13} = 'conditional_recall_(-1)neighbors';
% summary_header{14} = 'conditional_recall_(+1)neighbors';

%% data structure 
data.subjects = summary(:,1);
data.condition = summary(:,3);
data.listlength = 25;
data.recall_itemnos = recall_itemnos;
data.cond_rp = summary(data.condition==1,:);
data.cond_control = summary(data.condition==0,:);

%% calculate the averages 
summary_mean_control = NaN(n_sub-1,10);
summary_mean_rp = NaN(n_sub-1,10);

for i = 1:(n_sub-1) %because participant #12 is excluded here 
    
    summary_mean_control(i,1) = data.cond_rp((2*(i-1)+1),1); %subjects
    summary_mean_rp(i,1) = data.cond_rp((2*(i-1)+1),1);
    
    summary_mean_control(i,2) = 0; %condition
    summary_mean_rp(i,2) = 1;
    
    summary_mean_control(i,3) = NaN; % rp success
    summary_mean_rp(i,3) = mean(data.cond_rp((2*(i-1)+1):(2*i),4));
    
    summary_mean_control(i,4) = mean(data.cond_control(2*(i-1)+1:2*i,5)); % free recall
    summary_mean_rp(i,4) = mean(data.cond_rp(2*(i-1)+1:2*i,5));
    
    summary_mean_control(i,5) = mean(data.cond_control(2*(i-1)+1:2*i,6)); % critical item recall
    summary_mean_rp(i,5) = mean(data.cond_rp(2*(i-1)+1:2*i,6));
    
    summary_mean_control(i,6) = mean(data.cond_control(2*(i-1)+1:2*i,7)); % -1 neighbors
    summary_mean_rp(i,6) = mean(data.cond_rp(2*(i-1)+1:2*i,7));
    
    summary_mean_control(i,7) = mean(data.cond_control(2*(i-1)+1:2*i,8)); % +1 neighbors
    summary_mean_rp(i,7) = mean(data.cond_rp(2*(i-1)+1:2*i,8));
    
    summary_mean_control(i,8) = mean(data.cond_control(2*(i-1)+1:2*i,9)); % all temporal neighbors 
    summary_mean_rp(i,8) = mean(data.cond_rp(2*(i-1)+1:2*i,9));
end

% %% conditional recalls (strict)
% for i = 1:(n_sub-1)
%     if ~isnan(data.cond_rp((2*(i-1)+1),4))>0
%         if  ~isnan(data.cond_rp(2*i,12))>0
%             summary_mean_rp(i,8) = mean(data.cond_rp(2*(i-1)+1:2*i,12));    %critical item conditional recall
%             summary_mean_control(i,8) = mean(data.cond_control(2*(i-1)+1:2*i,6));
%             summary_mean_rp(i,9) = mean(data.cond_rp(2*(i-1)+1:2*i,13));    %-1 items conditional recall
%             summary_mean_control(i,9) = mean(data.cond_control(2*(i-1)+1:2*i,7));
%             summary_mean_rp(i,10) = mean(data.cond_rp(2*(i-1)+1:2*i,14));   %+1 items conditional recall
%             summary_mean_control(i,10) = mean(data.cond_control(2*(i-1)+1:2*i,8));
%         else
%             summary_mean_rp(i,8) = NaN; %critical item conditional recall
%             summary_mean_control(i,8) = NaN;
%             summary_mean_rp(i,9) = NaN;
%             summary_mean_control(i,9) = NaN;
%             summary_mean_rp(i,10) = NaN;
%             summary_mean_control(i,10) = NaN;
%         end
%     end
% end

%% conditional recalls (yoked pairs)


% mask control trials where the corresponding RP row is 0
block_rp = NaN(64,3);
block_control = NaN(64,3);
for i = 1:64
    if (data.cond_rp(i,4))>0 % retrieval practice success is greater than zero
        block_rp(i,1) = data.cond_rp(i,12); % critical item conditional recall
        block_control(i,1) = data.cond_control(i,6); % critical
        block_rp(i,2) = data.cond_rp(i,13); % -1 items conditional recall
        block_control(i,2) = data.cond_control(i,7);
        block_rp(i,3) = data.cond_rp(i,14); % +1 items conditional recall
        block_control(i,3) = data.cond_control(i,8);
    else
        block_rp(i,1) = NaN; %critical item conditional recall
        block_control(i,1) = NaN;
        block_rp(i,2) = NaN;
        block_control(i,2) = NaN;
        block_rp(i,3) = NaN;
        block_control(i,3) = NaN;
    end
end

for i = 1:(n_sub-1)
    summary_mean_rp(i,11) = nanmean(block_rp(2*(i-1)+1:2*i,1));    %critical item conditional recall
    summary_mean_control(i,11) = nanmean(block_control(2*(i-1)+1:2*i,1));
    summary_mean_rp(i,12) = nanmean(block_rp(2*(i-1)+1:2*i,2));    %-1 items conditional recall
    summary_mean_control(i,12) = nanmean(block_control(2*(i-1)+1:2*i,2));
    summary_mean_rp(i,13) = nanmean(block_rp(2*(i-1)+1:2*i,3));   %+1 items conditional recall
    summary_mean_control(i,13) = nanmean(block_control(2*(i-1)+1:2*i,3));
end



%
% cond_rp_rec_critical = NaN(64,1);
% cond_control_rec_critical = NaN(64,1);
% rp_success = data.cond_rp(:,4);
% critical = data.cond_rp(:,12);
% 
% for i = 1:64
%     if rp_success(i,1)==0 %if retrieval practice success is greater than 0
%         cond_rp_rec_critical(i,1) = NaN;
%         cond_control_rec_critical(i,1) = 
%         
%     else
%         cond_rp_rec_critical(i,1) = critical(i,1);
%         %cond_control_rec_critical(i,1) = NaN;
%     end
% end

% yoked pair stuff
%% conditional recall probability
yoked_summary_rp = NaN((n_sub-1)*2,3);
yoked_summary_c = NaN((n_sub-1)*2,3);
yoked_rp = NaN((n_sub-1)*2,100);
yoked_rp_backward = NaN((n_sub-1)*2,100);
yoked_rp_forward = NaN((n_sub-1)*2,100);
yoked_c = NaN((n_sub-1)*2,100);
yoked_c_backward = NaN((n_sub-1)*2,100);
yoked_c_forward = NaN((n_sub-1)*2,100);

critical = [7, 13, 19];

rp_itemnos_base = rp_itemnos(data.condition==1,:);
rp_itemnos_base_score = rp_itemnos_score(data.condition==1,:);
recall_itemnos_rp = recall_itemnos(data.condition==1,:);
recall_itemnos_control = recall_itemnos(data.condition==0,:);
recall_critical_rp = recall_critical(data.condition==1,:);
recall_critical_c = recall_critical(data.condition==0,:);
recall_critical_backward_rp = recall_critical_backward(data.condition ==1,:);
recall_critical_backward_c = recall_critical_backward(data.condition ==0,:);
recall_critical_forward_rp = recall_critical_forward(data.condition == 1,:);
recall_critical_forward_c = recall_critical_forward(data.condition == 0,:);
    
for i = 1:(n_sub-1)*2
    for j = 1:100
        for k = 1:3
            item = critical(k);
            % critical items (7, 13, 19)
            if any(rp_itemnos_base(i,:)==item)
                if (recall_itemnos_rp(i,j)==item)
                    yoked_rp(i,j) = recall_critical_rp(i,j);
                end
            end
            % -1 temporal contiguous items (6,12,18)
            if any(rp_itemnos_base(i,:)== (item))
                if (recall_itemnos_rp(i,j)== (item-1))
                    yoked_rp_backward(i,j) = recall_critical_backward_rp(i,j);
                end
            end
            % +1 temporal contiguous items (8,14,20)
            if any(rp_itemnos_base(i,:)== (item))
                if (recall_itemnos_rp(i,j)== (item+1))
                    yoked_rp_forward(i,j) = recall_critical_forward_rp(i,j);
                end
            end
        end
        yoked_summary_rp(i,1) = nansum(yoked_rp(i,:))/sum(rp_itemnos_base_score(i,:)); % conditional: critical items recall %
        yoked_summary_rp(i,2) = nansum(yoked_rp_backward(i,:))/sum(rp_itemnos_base_score(i,:)); % conditional: -1 items recalled
        yoked_summary_rp(i,3) = nansum(yoked_rp_forward(i,:))/sum(rp_itemnos_base_score(i,:)); % conditional: +1 items recalled
        
    end
end


for i = 1:(n_sub-1)*2
    for j = 1:100
        for k = 1:3
            item = critical(k);
            
            % critical items (7, 13, 19)
            if any(rp_itemnos_base(i,:)==item)
                if (recall_itemnos_control(i,j)==item)
                    yoked_c(i,j) = recall_critical_c(i,j);
                end
            end
            % -1 temporal contiguous items (6,12,18)
            if any(rp_itemnos_base(i,:)== (item))
                if (recall_itemnos_control(i,j)== (item-1))
                    yoked_c_backward(i,j) = recall_critical_backward_c(i,j);
                end
            end
            % +1 temporal contiguous items (8,14,20)
            if any(rp_itemnos_base(i,:)== (item))
                if (recall_itemnos_control(i,j)== (item+1))
                    yoked_c_forward(i,j) = recall_critical_forward_c(i,j);
                end
            end
        end
        yoked_summary_c(i,1) = nansum(yoked_c(i,:))/sum(rp_itemnos_base_score(i,:)); % conditional: critical items recall %
        yoked_summary_c(i,2) = nansum(yoked_c_backward(i,:))/sum(rp_itemnos_base_score(i,:)); % conditional: -1 items recalled
        yoked_summary_c(i,3) = nansum(yoked_c_forward(i,:))/sum(rp_itemnos_base_score(i,:)); % conditional: +1 items recalled
        
    end
end

for i = 1:(n_sub-1)
    yoked_summary_mean_rp(i,1) = nanmean(yoked_summary_rp(2*(i-1)+1:2*i,1));    %critical item conditional recall
    yoked_summary_mean_control(i,1) = nanmean(yoked_summary_c(2*(i-1)+1:2*i,1));
    yoked_summary_mean_rp(i,2) = nanmean(yoked_summary_rp(2*(i-1)+1:2*i,2));    %-1 items conditional recall
    yoked_summary_mean_control(i,2) = nanmean(yoked_summary_c(2*(i-1)+1:2*i,2));
    yoked_summary_mean_rp(i,3) = nanmean(yoked_summary_rp(2*(i-1)+1:2*i,3));   %+1 items conditional recall
    yoked_summary_mean_control(i,3) = nanmean(yoked_summary_c(2*(i-1)+1:2*i,3));
end

summary_header{12} = 'conditional_recall_critical';
summary_header{13} = 'conditional_recall_(-1)neighbors';
summary_header{14} = 'conditional_recall_(+1)neighbors';
            
% %% plot

spc_studypos_rp = spc(recall_itemnos_spc(data.condition==1,:),data.subjects(data.condition==1,:),data.listlength);
spc_studypos_control = spc(recall_itemnos_spc(data.condition==0,:),data.subjects(data.condition==0,:),data.listlength);

figure(1); % SPC by condition 

p1 = plot_spc(spc_studypos_rp);
ylim([0 1]); ylabel('Recall %'); xlabel('Studied Position'); xticks(1:1:25);
set(p1,'Color','black','markersize',5,'MarkerEdgeColor','black','MarkerFaceColor','black'); 
hold on
p2 = plot_spc(spc_studypos_control);
ylim([0 1]);ylabel('Recall Probability');xlabel('Studied Position');xticks(1:1:25);
set(p2,'Color',[0.75, 0.75, 0.75],'markersize',5,'MarkerEdgeColor',[0.75, 0.75, 0.75],'MarkerFaceColor',[0.75, 0.75, 0.75]); 
legend('Retrieval Practice','Control');
hold off

figure(2); % CRP overall 
lag_crp = crp(recall_itemnos_crp,data.subjects,data.listlength);
plot_crp(lag_crp);

figure(3); % CRP by condition 

crp_rp = crp(recall_itemnos_crp(data.condition==1,:),data.subjects(data.condition==1,:),data.listlength);
crp_control = crp(recall_itemnos_crp(data.condition==0,:),data.subjects(data.condition==0,:),data.listlength);
p3 = plot_crp(crp_rp);
ylim([0 0.6]);ylabel('Conditional Response Probability','FontSize',10);xlabel('Temporal Lag');
set(p3,'Color','black','markersize',5,'MarkerEdgeColor','black','MarkerFaceColor','black'); 
hold on

p4 = plot_crp(crp_control); 
ylim([0 0.6]);ylabel('Conditional Response Probability','FontSize',10);xlabel('Temporal Lag');xticks(-5:1:5);
set(p4,'Color',[0.75, 0.75, 0.75],'markersize',5,'MarkerEdgeColor',[0.75, 0.75, 0.75],'MarkerFaceColor',[0.75, 0.75, 0.75]); 
legend('retrieval practice','control');
hold off

set(findall(groot,'Type','axes'),'FontName','Times');
set(findall(groot,'Type','axes'),'FontSize',10);


%% how to characterize recall clustering by retrieval practiced items --
% 
% from_mask_rec = make_clean_recalls_mask2d(recalls);
% to_mask_rec = make_clean_recalls_mask2d(recalls);
% 
% from_mask_pres = zeros(n_trials, LL);
% from_mask_pres(:,7)=1;
% from_mask_pres(:,13)=1;
% from_mask_pres(:,19)=1;
% 
% lc_control = crp(recalls, subjects, LL, from_mask_rec, to_mask_rec, from_mask_pres);
% lc_practice = crp(recalls, subjects, LL, from_mask_rec, to_mask_rec, from_mask_pres);
% 