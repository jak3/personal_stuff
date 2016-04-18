#!/usr/bin/python
# pylint: disable=C0103
"""
Pragmatic pomodoro notification
"""

import sys
import time
import notify2

notify2.init('psh')

note = notify2.Notification('Pomodoro Timer', 'Start!')
note.show()

if len(sys.argv) == 1:
    MIN = 25
else:
    MIN = int(sys.argv[1])

time.sleep(MIN*60)
note.update('Pomodoro Timer', 'BREAK!', icon='/usr/share/pomodoro/pomi.png')
note.show()
