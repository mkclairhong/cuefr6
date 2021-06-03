Key points from the Instructions.pdf
1. Before you start the experiment, MAKE SURE TO CHECK THE PARTICIPANT #
https://docs.google.com/spreadsheets/d/19qtFgpA40RhAqY7pNuSunrul9YLvBl9gED3vSCgJ5no/edit?usp=sharing
2. Things to get ready (Write the participant # on top of the forms)
	a. Consent form
	b. Participant info form
	c. Receipts (if needed)
3. Give the (a) consent form at the very beginning: forms b&c need to be given out at the end.
4. Before running the PsychoPy code, make sure an empty Chrome browser is open in the testing room monitor (not the experimenter screen)
5. Begin the experiment by saying, "All the instructions you need for this study will be on the screen but let me know if you have any questions"
6. If a participant is getting paid, make sure to update it on the google drive.
https://docs.google.com/spreadsheets/d/1kunVUtJvTvWkl7KON3azE41UdtjJYWZC-7Y-j7kAtfk/edit#gid=2137759411



* Experiment paradigm summary
	* Design = Within Subjects (Retrieval Practice or Control)
	* Procedure
		1.Study (25 word list)
		2a.Retrieval Practice condition
			5min tetris
			Practice retrieving 3 of the words from the study list
			5 min tetris
		2b.Control
			10min tetris
		3. Free Recall
	* Repeat the procedure above for four sessions
	* At the end, do a free recall of ALL the target words from the previous session

* The experiment file folder must contain:
	* /tetris
	* /stimuli
	* /data

* On the windows machine,
	# Go to
	#	C:\Program Files\PsychoPy3\Lib\site-packages\psychopy\tools
	# change
	#   	QUERY_COUNTER = GL.GLuint()
	#   	GL.glGenQueries(1, ctypes.byref(QUERY_COUNTER))
	# to
	#   	QUERY_COUNTER = None
