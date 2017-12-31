#!/usr/bin/env python
# based on Lequn Chen's Code
import os
import sys
import binascii

INPUT = sys.argv[1]
OUTPUT = sys.argv[2]
STDOUTPUT = sys.argv[3]

s = open(INPUT, 'rb').read()
s = binascii.b2a_hex(s)
with open(STDOUTPUT, 'w') as f:
    for i in range(0, len(s), 2):
        f.write(str(s[i:i + 2])[2:-1])
        f.write('\n')

with open(OUTPUT, 'w') as f:
    for i in range(0, len(s), 8):
        f.write(str(s[i + 6:i + 8] + s[i + 4:i + 6] +
                    s[i + 2:i + 4] + s[i:i + 2])[2:-1])
        f.write('\n')
