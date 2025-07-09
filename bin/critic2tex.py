#!/usr/bin/env -S uv run --script# /// script
# dependencies = [
#   "pypandoc",
# ]
# ///

# Author: Dustin Wheeler
# Date: 2022-09-13
# Project: CriticMarkup
# License: Apache 2

# Modified from criticParser_CLI by Gabriel Weatherhead

# Command line script.
# Execute 'python critic2tex.py -h' from the command line for more help.


# Input is quoted UNIX type file path.

# Output is LaTeX formatted text using \deleted, \added, \hl,
# \todo, and \tinytodo tags, requires the todonotes and soul packages

# File is written to the same directory as the source unless
# an output is specified with the -o flag

# -o <file_path>    Writes file to specified path. Must include file name
# -b Opens the output HTML file in the default browser

import sys
import re
import argparse
from pathlib import Path
import tempfile
import pypandoc as pandoc


# Regex patterns for CriticMarkup input using re

add_pattern = r"(?s)\{\+\+(?P<value>.*?)\+\+\}"

del_pattern = r"(?s)\{\-\-(?P<value>.*?)\-\-\}"

comm_pattern = r"(?s)\{\>\>(?P<value>.*?)\<\<\}"

gen_comm_pattern = r"(?s)\{[ \t]*\[(?P<meta>.*?)\][ \t]*\}"

subs_pattern = r"(?s)\{\~\~(?P<original>(?:[^\~\>]|(?:\~(?!\>)))+)\~\>(?P<new>(?:[^\~\~]|(?:\~(?!\~\})))+)\~\~\}"

hl_pattern = r"(?s)\{\=\=(?P<value>.*?)\=\=\}\{\>\>(?P<comment>.*?)\<\<\}"


# Converts CriticMarkup to LaTeX


def deletionProcess(group_object):
    removeString = ""
    removeString = re.sub(r"(\\n){2,}", r"\\P", removeString)
    removeString = r"\deleted{" + group_object.group("value") + r"}"
    return removeString


def subsProcess(group_object):
    insString = r"\replaced{" + group_object.group("new") + r"}"
    delString = r"{" + group_object.group("original") + r"}"
    substString = insString + delString
    return substString


def additionProcess(group_object):
    addString = ""

    # Is there a new paragraph followed by new text
    if (
        group_object.group("value").startswith("\n\n")
        and group_object.group("value") != "\n\n"
    ):
        addString = "\n\n" + r"\added{\P" + group_object.group("value")
        addString = addString + r"}"

    # Is the addition just a single new paragraph
    elif group_object.group("value") == "\n\n":
        addString = "\n\n" + r"\added{\P}"

    # Is it added text followed by a new paragraph?
    elif (
        group_object.group("value").endswith("\n\n")
        and group_object.group("value") != "\n\n"
    ):
        addString = r"\added{" + group_object.group("value") + r"}"
        addString = addString + "\n\n" + r"\added{\P}" + "  \n"

    else:
        addString = r"\added{" + group_object.group("value") + r"}"

    return addString


def highlightProcess(group_object):
    replaceString = (
        r"\hl{"
        + group_object.group("value")
        + r"} \tinytodo{"
        + group_object.group("comment")
        + "}"
    )
    return replaceString


def commentProcess(group_object):
    replaceString = r" \todo[inline]{" + group_object.group("value") + "}"
    return replaceString


# Write a header which includes the packages `soul` (for highlighting) and
# `todonotes` (for margin notes, attribution of comments)
#
# TODO: Should this created in the markdown document header or in the final
# LaTeX document? Should the user (or script) just call a specific template?
# head = r'''\usepackage{soul}
# \usepackage{todonotes}
# '''

# h = sys.stdin.read()

parser = argparse.ArgumentParser(description="Convert Critic Markup to LaTeX")
parser.add_argument("source", help="The source file path, including file name")
parser.add_argument(
    "-o",
    "--output",
    help="Path to store the output file, including file name",
    metavar="out-file",
    type=argparse.FileType("wt"),
    required=False,
)

args = parser.parse_args()
try:
    if args.source:
        inputFile = open(args.source, "r")
        inputText = inputFile.read()
        inputFile.close()
    else:
        # log("No source file specified")
        print("No source file specified")
        sys.exit(1)

    h = inputText

    h = re.sub(del_pattern, deletionProcess, inputText, flags=re.DOTALL)

    h = re.sub(add_pattern, additionProcess, h, flags=re.DOTALL)

    h = re.sub(hl_pattern, highlightProcess, h, flags=re.DOTALL)

    # comment processing must come after highlights
    h = re.sub(comm_pattern, commentProcess, h, flags=re.DOTALL)

    h = re.sub(subs_pattern, subsProcess, h, flags=re.DOTALL)

    # clean yaml metadata keywords
    h = re.sub("Title:", "title:", h, flags=re.DOTALL)
    h = re.sub("Author:", "author:", h, flags=re.DOTALL)
    h = re.sub("Date:", "date:", h, flags=re.DOTALL)

    tmpfile = tempfile.NamedTemporaryFile(mode="w+", suffix=".md", dir=Path.cwd())
    tmpfile.write(h)

    # Why the hell is this read critical to writing the content to tmpfile?
    tmpfile.read()

    # If an output file is specified, write to it
    if args.output:
        filesource = args.output
        abs_path = Path.resolve(filesource.name)
        output_file = abs_path
    else:
        path = Path(args.source)
        output_file = path.parent / (path.stem + "_graded.pdf")

    print(f"Converting >> {args.source} to {output_file}")

    # Set template file location
    template_folder = Path.home() / ".local/share/pandoc/"
    template_file = "critic_grading.latex"

    h = pandoc.convert_file(
        tmpfile.name,
        format="markdown+yaml_metadata_block",
        to="pdf",
        outputfile=str(output_file),
        extra_args=["--template", template_file],
    )

    tmpfile.close()

except:
    print("Unexpected Error: ", sys.exc_info()[0])
    raise
