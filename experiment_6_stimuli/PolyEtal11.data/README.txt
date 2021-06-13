This archive contains a MATLAB-based data structure containing the behavioral data 
from the experiment described in the article:

Semantic cuing and the scale insensitivity of recency and contiguity

Sean M. Polyn, Gennady Erlikhman, and Michael J. Kahana

Journal of Experimental Psychology: Learning, Memory, and Cognition, Vol. 37 (3), 766-775.

Refer to this manuscript for the methods of the experiment, and description of the 
analyses that we carried out on these data.

%%%%%%%%%%%%%%%%%%%

This particular file written by Sean Polyn
sean.polyn@vanderbilt.edu
on September 27th, 2013

Send word if you find anything weird or out of sorts with the data, or the explanation of the organization of the data!

If you are interested in the Context Maintenance and Retrieval model of human memory, go to this webpage:
http://memory.psy.vanderbilt.edu/groups/vcml/wiki/618f3/CMR_Documentation.html

Behavioral Toolbox (Release 1) analysis code available from:
http://memory.psych.upenn.edu/behavioral_toolbox

%%%%%%%%%%%%%%%%%%%

A quick tour of the data structure.

%%%%%%%%%%%%%%%%%%%

If you load the file PolyEtal11_data.mat in MATLAB, you will find a
structure named 'data'. There are a number of sub-fields on the data
structure.  Each row corresponds to a particular trial.  If there is
more than one column, then there are two possible organizations, refer
below to see which one applies.  (1) Yoked to the presentation order,
each column corresponds to a study event.  (2) Yoked to the recall
order, each column corresponds to a recall event.

The careful observer will note that a handful of subjects have fewer
trials than others.  This is due to a minor coding error that affected
11 trials from the experiment.  We have excluded these trials from the
data structure.

The sub-fields:

data.subject		% Each row has a numerical index, a unique subject identifier.  There are 23 unique subject identifiers, integers
			        % ranging from 21 to 45.  

data.session		% A session label for each trial, either 2 or 3
data.trial		    	% The trial index, within the session (from 1 to 14).

data.pres_catnos     % A label for the category of each presented item.  Yoked to presentation order.

data.rec_task           % What recall task was used on this trial.  
			        % 1 = uncategorized list, free recall
				% 2 = categorized list, free recall
				% 3 = categorized list, recall-by-category

data.taskcatno	% for the recall by category lists, in what order were the three categories probed
data.task_cat	        % the name of the categories in text

data.rec_catnos		% The category index for each recalled item

data.times		% For each recall response, how many milliseconds after the onset of the recall period was this response made.

data.intrusions	% -1 for extra-experimental intrusion, positive numbers correspond to how many lists back a prior-list intrusion 
		     	        % came from. 

data.recalls		% A numerical identifier for each response made by the participant during the free recall period.  Integers 1-24   
			    	% correspond to the serial position of the recalled item.  Yoked to the recall order.  -1 corresponds to an intrusion.  

data.pres_cat		% The category of the presented word
data.rec_cat		% The category of the recalled word

data.rec_period	% On recall-by-category trials there were three recall
		     	        % periods, where each category was probed in turn.  Each element in here
				% corresponds to the recall period for each response made by a participant.
				% On free recall trials all recalls are assigned a value of 1

data.listLength	% There were 24 items on each study list

data.pres_items	% The presented word, in text, yoked to presentation order.
data.rec_items	      	% The recalled word, in text.
 

