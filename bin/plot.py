#!/usr/bin/env python3
# /// script
# dependencies = [
#   "numpy",
#   "matplotlib",
# ]
# ///

import numpy as np
import matplotlib.pyplot as plt
import sys
import getopt

usage = """plot [option] 'functions' minx maxx [miny maxy]

Options:
  -h, --help    print this message
  -f, --pdf     generate PDF plot (default is PNG)

Generate a PNG (default) or PDF plot of the given function(s). The
independent variable in the function(s) is x. Multiple functions are
separated by a semicolon. The min and max values can be given as
expressions. The output is typically redirected to a file.

Example:
  plot 'tan(x); x' pi 3*pi/2-.01 0 5 > plot.png

"""

# Handle the options.
try:
    opts, args = getopt.getopt(sys.argv[1:], "hf", ["help", "pdf"])
except getopt.GetoptError as err:
    sys.stderr.write(str(err) + "\n\n")
    sys.stderr.write(usage)
    sys.exit()

fmt = "png"
for o, a in opts:
    if o == "-f" or o == "--pdf":
        fmt = "pdf"
    else:
        sys.stderr.write(usage)
        sys.exit()

# Handle the arguments.
try:
    fcns = args[0].split(";")
    minx = eval(args[1])
    maxx = eval(args[2])
except IndexError:
    sys.stderr.write(usage)
    sys.exit()

plt.xlim(minx, maxx)
try:
    miny = float(args[3])
    maxy = float(args[4])
    plt.ylim(miny, maxy)
except IndexError:
    pass

# Make the plot.
x = np.linspace(minx, maxx, 100)
for i, f in enumerate(fcns):
    y = eval(f)
    plt.plot(x, y, "-", linewidth=2)

plt.minorticks_on()
plt.grid(which="both", color="#dddddd")

# Output the plot.
if fmt == "pdf":
    plt.savefig(sys.stdout.buffer, format="pdf")
else:
    plt.savefig(sys.stdout.buffer, format="png")
