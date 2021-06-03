
from __future__ import absolute_import, division, print_function
################For WINDOWS (for mac, comment out)#########################
#import pyglet
#pyglet.options['shadow_window']=False
#-------------------------------------------------------------------------#
##https://discourse.psychopy.org/t/unable-to-share-contexts-error-when-creating-window/9853
## Go to C:\Program Files\PsychoPy3\Lib\site-packages\psychopy\tools
## change
##   QUERY_COUNTER = GL.GLuint()
##   GL.glGenQueries(1, ctypes.byref(QUERY_COUNTER))
## to
##   QUERY_COUNTER = None
#-------------------------------------------------------------------------#
from builtins import range
from psychopy import locale_setup, prefs, sound, gui, visual, core, data, event, logging, clock
from psychopy.constants import (NOT_STARTED, STARTED, PLAYING, PAUSED,
                                STOPPED, FINISHED, PRESSED, RELEASED, FOREVER)
from numpy import (sin, cos, tan, log, log10, pi, average,
                   sqrt, std, deg2rad, rad2deg, linspace, asarray)
from psychopy.hardware import keyboard
import os
import sys
import random
import math
import pandas as pd
import numpy as np
import webbrowser
import string
import json

# avoid getting .pyc files
sys.dont_write_bytecode = True

##########################################
#         Experiment Parameters          #
##########################################

#-------------------------------------------------------------------------#
# vars        | values     | default     | description                    #
#-------------------------------------------------------------------------#
n_trials      = 25            # 8        | number of trials (words) within a session
n_session     = 4             # 4        | total 4 sessions (2xretrieval practice, 2xcontrol)
# durations (in seconds)
dur_stim      = 5             # 5        | stimuli presentatation time (seconds)
dur_isi       = 1             # 1        | interstimulus interval (seconds)
tetris_five   = 300           # 300      | tetris duration in between study and retrieval practice (seconds)
tetris_ten    = 600           # 600      | tetris duration in between study and free recall in control (seconds)
tetris_three  = 180           # 180      | tetris duration in between sessions (seconds)
# miscellenious
fullscreen    = False
psychopyVersion = '3.2.4'

# store info about the experiment session
expInfo = {'participant': ''}
expInfo['expName'] = 'exp_RW_6_'
dlg = gui.DlgFromDict(dictionary=expInfo, title=expInfo['expName'])  # sortKeys=False,
if not dlg.OK:
    core.quit()  # user pressed cancel

# recursively find the root experiment directory
pwd = os.getcwd()
while os.path.basename(pwd) != 'cuefr6':
    os.chdir('..')
    pwd = os.getcwd()
rootDir = os.getcwd()
# double check that the subjectID does not exist already
exp_subj = expInfo['participant']
subjDir = rootDir + '/data/' + expInfo['expName'] + exp_subj
assert not os.path.isdir(subjDir), "Subject data already exists. Quitting"
os.mkdir(subjDir)

#   Creating Windows 1915 x 1050 for windows
win = visual.Window([1915,1050], fullscr=False, monitor='testMonitor', color=[-1,-1,-1], colorSpace='rgb')

expInfo['date'] = data.getDateStr()
expInfo['frameRate'] = win.getActualFrameRate()
expInfo['psychopyVersion'] = psychopyVersion
#frameRate = expInfo['frameRate']
frameRate = 60
# write a separate exp text file to the subject directory
with open(subjDir + '/subj' + str(exp_subj) + '_info.txt', 'w') as file:
     file.write(json.dumps(expInfo))

#-----------------------------------------------------------------------#
# Stimuli characteristics
# Instructions
IntstructionText = visual.TextStim(win=win, text="", font='Calibri',
    pos=(0, 0), height=0.9, wrapWidth=None, ori=0,
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0,units='cm')
# Presented stimuli
stimText = visual.TextStim(win=win,text="",font='Calibri',
    pos=(0, 0), height=0.9, wrapWidth=None, ori=0,
    color='white', colorSpace='rgb', opacity=1, units='cm')
# category (top) target(bottom)
stimText_cat = visual.TextStim(win=win,text="",font='Calibri',
    pos=(0, +3), height=0.5, wrapWidth=None, ori=0,
    color='white', colorSpace='rgb', opacity=1, units='cm')
stimText_target = visual.TextStim(win=win,text="",font='Calibri',
    pos=(0, -3), height=1.9, wrapWidth=None, ori=0,
    color='white', colorSpace='rgb', opacity=1, units='cm')
stimText_rp = visual.TextStim(win=win,text="",font='Calibri',
    pos=(0, -3), height=0.9, wrapWidth=None, ori=0,
    color='white', colorSpace='rgb', opacity=1, units='cm')
textResponse = visual.TextStim(win=win,text="", font='Calibri',
    pos=(10, 0), height=0.9, wrapWidth=None, ori=0,
    color='black', colorSpace='rgb', opacity=1, units='cm')
textBox = visual.Rect(win=win, lineColor='black', fillColor='white', size=[60, 4], pos=(0, 0), units='cm')
#-----------------------------------------------------------------------#

# read in and setup stimuli
stimDir = rootDir + '/stimuli'
stim_file = stimDir + '/stim_subj_' + exp_subj + '.csv'
stim_file = pd.read_csv(stim_file, index_col=None)
# assign each column values as variables
stim_category = stim_file['category']
stim_target = stim_file['target']
stim_rp = stim_file['rp']

#-----------------------------------------------------------------------#
# initialize exp dataframe
data_columns = ['session', 'index', 'condition', 'type', 'stim', 'response', 'trialtime', 'globaltime', 'recall1', 'recall2', 'recall3', 'recall4', 'recall5']
data = pd.DataFrame(columns=data_columns)

##########################################
#               Functions                #
##########################################
def print_and_save(string, clock, resDir, type):
    string = str(string)
    print(string)
    timer = clock.getTime()
    with open(resDir + '/consolePrint_' + str(exp_subj) + '.txt', str(type)) as file:
        file.write(str(timer) + ' | ' + string + '\n')


def show_blank_screen(dur_isi):
    """
    show blank screen in between words. Duration is in SECONDS.
    """
    stimText.text = " "
    for frameN in range(int(dur_isi*frameRate)):
        stimText.draw()
        win.flip()

def show_instruction(instr):
    IntstructionText.text = instr
    IntstructionText.draw()
    win.flip()
    inst_key = event.waitKeys(keyList=['space'])


def tetris(tetris_duration):
    inst_key = event.waitKeys(keyList=['space'])
    print_and_save('starting Tetris', expTimer, subjDir, 'a')
    tetris_path = 'tetris/javascript-tetris-master/index.html'
    webbrowser.open('file://'+os.path.realpath(tetris_path))
    core.wait(int(tetris_duration))
    #   for Windows
    #os.system("taskkill /im chrome.exe")
    #   for mac
    os.system("killall -9 'Google Chrome'")


def study(numlist):
    """
    present study items (numlist = 1 for 1st list, etc.)
    """
    global data
    temp_df = pd.DataFrame(columns=data_columns)
    event.clearEvents('keyboard')  # clear keyboard buffer
    for i in range(n_trials*(numlist-1), n_trials*(numlist)):
        temp_str = 'Session ' + str(numlist) + ' | Item index ' + str(i+1) + ' | Target: ' + stim_target[i].lower() + ' (Category: ' + str(stim_category[i].lower()) + ')'
        print_and_save(temp_str, expTimer, subjDir, 'a')
        # now show category (top row) target (bottom row)
        stimText_cat.text = stim_category[i]
        stimText_target.text = stim_target[i]
        for frameN in range(int(dur_stim*frameRate)):
            # add timestamp of the very first frame
            if frameN == 0:
                temp_df.at[i, 'trialtime'] = trialTimer.getTime()
                temp_df.at[i, 'globaltime'] = expTimer.getTime()
            stimText_cat.draw()
            stimText_target.draw()
            win.flip()
        # show blank screen in between words
        show_blank_screen(dur_isi)

        # save to temporary dataframe
        temp_df.at[i, 'session'] =  numlist
        temp_df.at[i, 'index'] =  i + 1
        temp_df.at[i, 'type'] =  'study'
        temp_df.at[i, 'condition'] =  condition
        temp_df.at[i, 'stim'] =  stim_target[i].lower()
        temp_df.at[i, 'response'] =  []
    data = data.append(temp_df)


def rp(numlist):
    """
    Retrieval Practice 2nd, 8th, and 14th on the critical list (Whole list: 7th, 13th, 19th, -1 for python index)
    """
    rp_list = [n_trials*(numlist-1)+6,n_trials*(numlist-1)+12,n_trials*(numlist-1)+18]
    random.shuffle(rp_list)
    global data
    temp_df = pd.DataFrame(columns=data_columns)
    event.clearEvents('keyboard')  # clear keyboard buffer
    for i in range(0,3):
        temp_str = 'Session ' + str(numlist) + ' | Retrieval Prac ' + str(i+1) + ' | Presented: ' + stim_rp[rp_list[i]]
        print_and_save(temp_str, expTimer, subjDir, 'a')
        stimText_rp.text = stim_rp[rp_list[i]]
        allLetters = list(string.ascii_lowercase)
        key_input = ''
        recall_start = True
        rp_start = expTimer.getTime()
        while recall_start:
            keys = event.getKeys()
            if keys:  # if any key is pressed, keys[0] = letter, keys[1] = timestamp
                if keys[0] == 'space':               # add a space
                    key_input += ' '
                elif keys[0] == 'backspace':         # delete last keystroke
                    key_input = key_input[:-1]
                elif keys[0] in allLetters:          # if letter is pressed, add to keyboard buffer
                    key_input += keys[0]
                elif keys[0] in 'return':            # if enter, proceed to next
                    recall_start = False
                    key_output = ''.join(key_input)  # get the final text output saved
                    rp_end = expTimer.getTime()
            stimText_rp.draw()
            textBox.draw()
            textResponse.draw()
            win.flip()
            textResponse.setText(key_input)
        event.clearEvents('keyboard')  # clear keyboard buffer
        temp_str = 'RP ' + str(i + 1) + ' Response: ' + key_output
        print_and_save(temp_str, expTimer, subjDir, 'a')
        # show blank screen in between words
        show_blank_screen(dur_isi)

        # save to temporary dataframe
        temp_df.at[i, 'session'] =  numlist
        temp_df.at[i, 'index'] =  i + 1
        temp_df.at[i, 'type'] =  'rp'
        temp_df.at[i, 'condition'] =  condition
        temp_df.at[i, 'stim'] =  stim_rp[rp_list[i]].lower()
        temp_df.at[i, 'response'] =  key_output
        temp_df.at[i, 'trialtime'] =  rp_end - rp_start
        temp_df.at[i, 'globaltime'] = rp_start
    # save out the file
    data = data.append(temp_df)
    data = data.reindex(columns=data_columns)
    data.to_csv(subjDir + '/' + expInfo['expName'] + str(exp_subj) + '.csv', index=False)


def recall(numlist):
    global data
    temp_df = pd.DataFrame(columns=data_columns)
    event.clearEvents('keyboard')  # clear keyboard buffer
    for i in range(0,50):
        allLetters = list(string.ascii_lowercase)
        key_input = ''
        recall_start = True
        continueRoutine = True
        rc_start = expTimer.getTime()
        while recall_start:
            keys = event.getKeys()
            if keys:  # if any key is pressed, keys[0] = letter, keys[1] = timestamp
                if keys[0] == 'space':               # add a space
                    key_input += ' '
                elif keys[0] == 'backspace':         # delete last keystroke
                    key_input = key_input[:-1]
                elif keys[0] in allLetters:          # if letter is pressed, add to keyboard buffer
                    key_input += keys[0]
                elif keys[0] in 'return':            # if enter, proceed to next
                    recall_start = False
                    key_output = ''.join(key_input)  # get the final text output saved
                    rc_end = expTimer.getTime()
                elif keys[0] in 'escape':
                   continueRoutine = False
            if not continueRoutine:
                break
            textBox.draw()
            textResponse.draw()
            win.flip()
            textResponse.setText(key_input)

        event.clearEvents('keyboard')  # clear keyboard buffer
        temp_str = 'Session ' + str(numlist) + ' | Recall item ' + str(i+1) + ' | Recalled: ' + key_output
        print_and_save(temp_str, expTimer, subjDir, 'a')

        # save to temporary dataframe
        temp_df.at[i, 'session'] =  numlist
        temp_df.at[i, 'index'] = i + 1
        if numlist == 5:
            temp_df.at[i, 'type'] =  'final_recall'
        else:
            temp_df.at[i, 'type'] =  'recall'
        temp_df.at[i, 'condition'] =  condition
        temp_df.at[i, 'stim'] =  []
        temp_df.at[i, 'response'] =  key_output
        temp_df.at[i, 'recall'+str(numlist)] = key_output
        temp_df.at[i, 'trialtime'] =  rc_end - rc_start
        temp_df.at[i, 'globaltime'] = rc_start

        if key_input == 'done':
            continueRoutine = False
            # save out the file
            data = data.append(temp_df)
            data = data.reindex(columns=data_columns)
            data.to_csv(subjDir + '/' + expInfo['expName'] + str(exp_subj) + '.csv', index=False)
            break
        if not continueRoutine:
            break

#-----------------------------------------------------------------------#
#   Condition assignment
#-----------------------------------------------------------------------#
cond_list = [1,0,1,0]   # 0 = Control, 1 = Retrieval Practice
random.shuffle(cond_list) # Randomize the sequence of conditions

# start global exp clock
expTimer = core.Clock()

# start logging
logging.setDefaultClock(expTimer)
logging.console.setLevel(logging.ERROR)  # logging.DEBUG to show all messages
logData = logging.LogFile(subjDir + '/' + expInfo['expName'] + str(exp_subj) + '.log', filemode='w', level=logging.DEBUG)  # INFO
txtDir = subjDir + '/consolePrint.txt'
############################ Sessions  ##################################
instr = "Welcome! Please read and sign the consent form in front of you. Please put your phone on silent and away."
show_instruction(instr)

#-----------------------------------------------------------------------#
#   Practice
#-----------------------------------------------------------------------#
instr = "In this experiment, you will study a list of words and recall them for a later memory test in each session. There will be a total of 4 sessions in this experiment. Before we begin, we will go through a short practice round to preview the experiment. \n\nPress the spacebar to begin."
show_instruction(instr)

instr = "Frist, we will show you a list of words. Your job is to study each one of them carefully and remember those for a later memory test. \n\nOn each screen, you will see a word pair: a CATEGORY (top, shown in UPPERCASE) and a target (bottom, shown in lowercase). You only have to remember the *target* words for the memory test. \n\nPress the spacebar to move onto the next screen."
show_instruction(instr)

for i in range (0,3):
    practice_category = ["BEVERAGES", "BOY NAMES", "CHEMICAL ELEMENT"]
    practice_target = ["lemonade", "dave", "boron"]
    stimText_cat.text = practice_category[i]
    stimText_target.text = practice_target[i]
    for frameN in range(int(dur_stim*frameRate)):
        stimText_cat.draw()
        stimText_target.draw()
        win.flip()
    # show blank screen in between words
    show_blank_screen(dur_isi)

instr = "Then, you may be asked you to practice recalling some of the target words from the study list. You will be shown the first letter of a word (e.g. 'w _ _ _') - your job is to recall what the word was to the best of your abilities. \n\nPress the spacebar to move onto the next screen."
show_instruction(instr)

instr = "When you recall a word, type out the ENTIRE word that fits the prompt (e.g. w_ _ _: 'word' instead of just 'ord'). If you cannot recall it, copy the first letter and press enter (e.g. type 'w' in the blank). \n\nPress the spacebar to move onto the next screen."
show_instruction(instr)

for i in range(0,1):
        stimText_rp.text = "b_ _ _ _"
        allLetters = list(string.ascii_lowercase)
        key_input = ''
        recall_start = True
        while recall_start:
            keys = event.getKeys()
            if keys:  # if any key is pressed, keys[0] = letter, keys[1] = timestamp
                if keys[0] == 'space':               # add a space
                    key_input += ' '
                elif keys[0] == 'backspace':         # delete last keystroke
                    key_input = key_input[:-1]
                elif keys[0] in allLetters:          # if letter is pressed, add to keyboard buffer
                    key_input += keys[0]
                elif keys[0] in 'return':            # if enter, proceed to next
                    recall_start = False
                    key_output = ''.join(key_input)  # get the final text output saved
                    rp_end = expTimer.getTime()
            stimText_rp.draw()
            textBox.draw()
            textResponse.draw()
            win.flip()
            textResponse.setText(key_input)
        event.clearEvents('keyboard')  # clear keyboard buffer
        # show blank screen in between words
        show_blank_screen(dur_isi)

instr = "The correct response would be 'boron' - once again, you MUST type out the entire word that fits your recall prompt (e.g. 'boron' instead of 'oron'). Or, if you couldn't remember the word, you should have typed just 'b' in the given blank. In the actual experiment, you will not be given feedback about the correct responses. \n\nPress the spacebar to move onto the next screen."
show_instruction(instr)

instr = "For the final test, we will ask you to recall ALL of the target words you saw from the study list. Type one word in EACH blank and press enter. When you cannot recall any more words, type 'done' in the given blank. \n\nPress the spacebar to begin the recall test."
show_instruction(instr)

for i in range(0,3):
        allLetters = list(string.ascii_lowercase)
        key_input = ''
        recall_start = True
        continueRoutine = True
        while recall_start:
            keys = event.getKeys()
            if keys:  # if any key is pressed, keys[0] = letter, keys[1] = timestamp
                if keys[0] == 'space':               # add a space
                    key_input += ' '
                elif keys[0] == 'backspace':         # delete last keystroke
                    key_input = key_input[:-1]
                elif keys[0] in allLetters:          # if letter is pressed, add to keyboard buffer
                    key_input += keys[0]
                elif keys[0] in 'return':            # if enter, proceed to next
                    recall_start = False
                    key_output = ''.join(key_input)  # get the final text output saved
                    rc_end = expTimer.getTime()
                elif keys[0] in 'escape':
                   continueRoutine = False
            if not continueRoutine:
                break
            textBox.draw()
            textResponse.draw()
            win.flip()
            textResponse.setText(key_input)

instr = "The correct responses would be 'lemonade', 'dave', 'boron' in EACH blank. In the actual experiment, when you cannot remember any more words, you should type 'done' in the blank. \n\nPress the spacebar to move onto the next screen."
show_instruction(instr)

instr = "This is the end of the practice phase. Well done! \n\n Any questions about the experiment? Please ask the experimenter now.  \n\n When you are ready, press the spacebar to begin the experiment."
show_instruction(instr)

#-----------------------------------------------------------------------#
#   Begin experiment
#-----------------------------------------------------------------------#
for j in range(0, n_session):
    trialTimer = core.Clock()
    numlist = j+1
    condition = cond_list[j]
    #-----------------------------------------------------------------------#
    #   1. Study List
    #-----------------------------------------------------------------------#
    #   Instructions
    if numlist == 1:
        instr = "During this first session, we will show you a list of words. Your job is to study each of them carefully and remember those for a later memory test. \n\nOn each screen, you will see a word pair: a CATEGORY (top, shown in UPPERCASE) and a target (bottom, shown in lowercase).  \n\nPress the spacebar to move onto the next screen."
        show_instruction(instr)

    if numlist > 1:
        instr = "Before we move onto the next session, please feel free to take a break (check your phone, use the restroom, have a snack, stretch, etc.) if you need.  \n\nPress the spacebar when you are ready to begin the next session."
        show_instruction(instr)

        instr = "Welcome back! During this session, we will show you a list of words like before. Your job is to study each of them carefully and remember those for a later memory test. On each screen, you will see a word pair: a CATEGORY (top, shown in UPPERCASE) and a target (bottom, shown in lowercase). \n\nPress the spacebar to move onto the next screen."
        show_instruction(instr)

    instr = "Remember, you only have to recall the *target* words (shown in lowercase on the bottom of the screen) for the memory test. \n\nPress the spacebar when you are ready!"
    show_instruction(instr)

    study(numlist)  #   Present List 1

    if cond_list[j] == 1:    # This is a Retrieval Practice session
        #-----------------------------------------------------------------------#
        #   2A. Cond = 1: Tetris(5m) + Retrieval Practice + Teris (5m)
        #-----------------------------------------------------------------------#
        instr = "During the next phase, we will ask you to play tetris five minutes. Use the left/right/up/down keys to move the block. \n\nPress the spacebar twice to begin."
        show_instruction(instr)
        tetris(tetris_five)

        instr = "Now, we will ask you to recall some of the words you've seen during the study phase. You will be shown the first letter of a word - your job is to recall what the word was to the best of your abilities. When you recall a word, type out the ENTIRE word that fits the prompt (e.g. w_ _ _: 'word' instead of just 'ord'). If you cannot recall it, copy the first letter and press enter (e.g. type 'w' in the blank). \n\nPress the spacebar to move onto the next screen."
        show_instruction(instr)
        instr = "We know that it can be difficult to recall the correct target word just by seeing the first letter, but please try your best! \n\n If you have any questions, please let the experimenter know now. Otherwise, press the spacebar to begin."
        show_instruction(instr)
        instr = "Remember, you recall a word, type out the ENTIRE word that fits the prompt (e.g. w_ _ _: 'word' instead of just 'ord'). \n\nPress the spacebar to begin."
        show_instruction(instr)

        rp(numlist) #   Present RP prompts

        instr = "During the next phase, we will ask you to play tetris again for five minutes. Use the left/right/up/down keys to move the block. \n\nPress the spacebar twice to begin."
        show_instruction(instr)
        tetris(tetris_five)

    elif cond_list[j] == 0: # This is a Control condition session
        #-----------------------------------------------------------------------#
        #   2B. Cond = 0: Tetris (10m)
        #-----------------------------------------------------------------------#
        instr = "During the next phase, we will ask you to play tetris for ten minutes. Use the left/right/up/down keys to move the block. \n\nPress the spacebar twice to begin."
        show_instruction(instr)
        tetris(tetris_ten)
    #-----------------------------------------------------------------------#
    #   3. Free recall
    #-----------------------------------------------------------------------#
    instr = "Now recall all the TARGET words you can remember from the study list you saw during THIS CURRENT session. \n\nType ONE WORD on each screen and press enter. Type 'done' when you cannot remmeber any more words. \n\nPress the spacebar to begin."
    show_instruction(instr)
    #   Present free recall prompts
    recall(numlist)
    logging.flush()

    #-----------------------------------------------------------------------#
    #   4. End of Session Tetris
    #-----------------------------------------------------------------------#
    if numlist == 1:
        instr = "Great work! This is the end of Session 1. Now, before we move onto session 2, we will ask you to play tetris again for three minutes. After Tetris, you will have a chance to take a break if you need. \n\nPress the spacebar twice to begin Tetris."
        show_instruction(instr)
        tetris(tetris_three)
    if numlist == 2:
        instr = "Great work! This is the end of Session 2. Now, before we move onto session 3, we will ask you to play tetris again for three minutes. After Tetris, you will have a chance to take a break if you need. \n\nPress the spacebar twice to begin Tetris."
        show_instruction(instr)
        tetris(tetris_three)
    if numlist == 3:
        instr = "Great work! This is the end of Session 3. Now, before we move onto session 4, we will ask you to play tetris again for three minutes. After Tetris, you will have a chance to take a break if you need. \n\nPress the spacebar twice to begin Tetris."
        show_instruction(instr)
        tetris(tetris_three)
    if numlist == 4:
        instr = "Great work! This is the end of Session 4. Now, before we move on, we will ask you to play tetris again for three minutes. After Tetris, you will have a chance to take a break if you need. \n\nPress the spacebar twice to begin Tetris."
        show_instruction(instr)
        tetris(tetris_three)
#-----------------------------------------------------------------------#
#   5. Free recall of ALL the target words from the study list
#-----------------------------------------------------------------------#
instr = "Now recall all the TARGET words you can remember from the lists you studied throughout the entire experiment. Type 'done' when you cannot remmeber any more words. \n\nPress the spacebar to begin."
show_instruction(instr)
#   Present free recall prompts
recall(5)
logging.flush()
#-----------------------------------------------------------------------#
# save out data
data = data.reindex(columns=data_columns)
data.to_csv(subjDir + '/' + expInfo['expName'] + str(exp_subj) + '.csv', index=False)
#-----------------------------------------------------------------------#

# End the experiment
#-----------------------------------------------------------------------#
# save out data
data = data.reindex(columns=data_columns)
data.to_csv(rootDir + '/data/exp_RW6_data_subj_' + str(exp_subj) + '.csv', index=False)
#-----------------------------------------------------------------------#

# End the experiment
endingText = "This is the end! Thank you for your participation. In this experiment, we aim to examine how retrieval practice affects your memory. Based on past studies, we predict that practice retrieving the target words will not only improve your memory for the items you recalled, but also those that were studied around them. If you have any questions, please contact clair.hong@vanderbilt.edu"
IntstructionText.text = endingText
IntstructionText.draw()
win.flip()
# wait for 2 seconds and then quit out of PsychoPy
core.wait(2)
print_and_save('end of experiment!', expTimer, subjDir, 'a')
core.quit()
