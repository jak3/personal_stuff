""" Examples:
                           [ISO FORMAT ] [HOURS]
    1. python timedelta.py 2021-05-07T11 52

                           [ISO FORMAT ] [ISO FORMAT]
    2. python timedelta.py 2021-05-07T11 2021-05-09T11
"""

import sys
from datetime import timedelta, datetime

da = datetime.fromisoformat(sys.argv[1])
DELTA = None

try:
    DELTA = timedelta(hours=int(sys.argv[2]))
except ValueError as err:
    ada = datetime.fromisoformat(sys.argv[2])

if DELTA:
    print(da+DELTA)
else:
    print(ada-da)
