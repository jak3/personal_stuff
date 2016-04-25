#!/usr/bin/python
# pylint: disable=C0103
"""
Pragmatic pomodoro notification
"""

import notify2
import os
import sys
import time

notify2.init('psh')

note = notify2.Notification('Pomodoro Timer', 'Start!')
note.show()

if len(sys.argv) == 1:
    MIN = 25
else:
    MIN = int(sys.argv[1])

time.sleep(MIN*60)
note.update('Pomodoro Timer', 'BREAK!', icon='/usr/share/pomodoro/pomi.png')
os.system("play --no-show-progress --null --channels 1 synth 0.1 sine 1000")
note.show()
