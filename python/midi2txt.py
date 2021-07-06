from timidity import Parser, play_notes
import numpy as np
import csv
from pathlib import Path

song_name = input('Enter your song name:')
ps = Parser("songs/"+song_name+".mid")
notes, ticks_per_quarter, bpm=(ps.parse())

with open('scores/'+song_name+'.csv', mode='w') as song_file:
    writer = csv.writer(song_file)
    fieldnames = ['pitch', 'velocity', 'start', 'end']
    writer.writerow(fieldnames)
    writer.writerows(notes)
    writer.writerow([ticks_per_quarter, bpm, 0, 0])
