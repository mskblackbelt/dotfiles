#!/usr/bin/env -S uv run --script
# /// script
# dependencies = [
#   "numpy",
#   "matplotlib",
# ]
# ///

import numpy as np
import matplotlib.pyplot as plt
import sys
import re
import getopt

usage = """pplot [option] [minx maxx [miny maxy]]

Options:
  -h, --help    print this message
  -f, --pdf     generate PDF plot (default is PNG)
  -l, --line    connect points with a line

Generate a PNG (default) or PDF plot of the given data. Each line of input 
data represents one (x, y) point. The x and y values can be separated by tabs, 
spaces, or commas. Normally, pplot plots only the points. If you want to 
connect the points with a line, use the -l option. The output is typically 
redirected to a file.

The optional min and max values set the axis limits. 

Example:
  pbpaste | pplot 0 5 > plot.png

"""

# Handle the options.
try:
    opts, args = getopt.getopt(sys.argv[1:], "hfl", ["help", "pdf", "line"])
except getopt.GetoptError as err:
    sys.stderr.write(str(err) + "\n\n")
    sys.stderr.write(usage)
    sys.exit()

marker = "."
fmt = "png"
for o, a in opts:
    if o in ("-h", "--help"):
        sys.stdout.write(usage)
        sys.exit()
    elif o in ("-l", "--line"):
        marker = ".-"
    elif o in ("-f", "--pdf"):
        fmt = "pdf"

# Handle the arguments.
try:
    minx = float(args[0])
    maxx = float(args[1])
    plt.xlim(minx, maxx)
except IndexError:
    pass

try:
    miny = float(args[2])
    maxy = float(args[3])
    plt.ylim(miny, maxy)
except IndexError:
    pass

x = []
y = []
for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    vals = re.split(r"\s+|\s*,\s*", line)
    x.append(vals[0])
    y.append(vals[1])
x = [np.float64(i) for i in x]
y = [np.float64(i) for i in y]
fig = plt.plot(x, y, marker)
plt.margins(0.05)
plt.minorticks_on()
plt.grid(which="both", color="#dddddd")


# Output the plot.
if fmt == "pdf":
    plt.savefig(sys.stdout.buffer, format="pdf")
else:
    plt.savefig(sys.stdout.buffer, format="png")
