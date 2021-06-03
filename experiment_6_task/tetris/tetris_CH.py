#-----------------------------------------------------------------------#
# Tetris
#-----------------------------------------------------------------------#
# Instructions
TetrisText = " Your instructions here. \n\nPress the spacebar to begin."
IntstructionText.text = TetrisText
IntstructionText.draw()
win.flip()
# then the event.waitKeys lets the script wait until the certain key is pressed to proceed to the next line of the script
inst_key = event.waitKeys(keyList=['space'])

print('testing TETRIS NOW')
tetris_path = 'javascript-tetris-master/index.html'
webbrowser.open('file://'+os.path.realpath(tetris_path))
core.wait(int(dur_tetris_rp))
#   for Windows
os.system("taskkill /im chrome.exe")
#   for mac 
#os.system("killall -9 'Google Chrome'")