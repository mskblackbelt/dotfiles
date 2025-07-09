#!/usr/bin/env -S uv run --script
# /// script
# ///

import sys

vals = sys.argv[1]

blocks = "▁▂▃▄▅▆▇██"


def spark(data):
    line = ""
    lo = float(min(data))
    hi = float(max(data))
    incr = (hi - lo) / 8
    for n in data:
        line += blocks[int((float(n) - lo) / incr)]
    return line


sys.stdout.write(spark([float(x) for x in vals.split()]) + "\n")
