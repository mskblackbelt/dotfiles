#!/usr/bin/python3

# Author: Dustin Wheeler
# Date: 2016-10-20
# Project: CriticMarkup
# License: Apache 2

# Modified from criticParser_CLI by Gabriel Weatherhead

# Command line script. Execute 'python critic2tex.py -h' from the command line for more help.


# # Input is quoted UNIX type file path.

# Output is LaTeX formated text using \deleted, \added, and \tinytodo tags, requires the todonotes and soul packages

# File is written to the same directory as the source unless specified with the -o flag

# -o <file_path>    Writes file to specified path. Must include file name
# 
# -b Opens the output HTML file in the defualt browser


import sys
import os
import re
import argparse
import subprocess


#Regex patterns for CriticMarkup input using re

add_pattern = r'(?s)\{\+\+(?P<value>.*?)\+\+\}'

del_pattern = r'(?s)\{\-\-(?P<value>.*?)\-\-\}'

comm_pattern = r'(?s)\{\>\>(?P<value>.*?)\<\<\}'

gen_comm_pattern = r'(?s)\{[ \t]*\[(?P<meta>.*?)\][ \t]*\}'

subs_pattern = r'(?s)\{\~\~(?P<original>(?:[^\~\>]|(?:\~(?!\>)))+)\~\>(?P<new>(?:[^\~\~]|(?:\~(?!\~\})))+)\~\~\}'

hl_pattern = r'(?s)\{\=\=(?P<value>.*?)\=\=\}\{\>\>(?P<comment>.*?)\<\<\}'


# Converts CriticMarkup to LaTeX

def deletionProcess(group_object):
	removeString = ''
	if group_object.group('value') == '\n\n':
		removeString = r'\deleted{\P}'
	else:
		removeString = r'\deleted{' + group_object.group('value') + r'}'
	return removeString


def subsProcess(group_object):
	insString = r'\replaced{' + group_object.group('new') + r'}'
	delString = r'{' + group_object.group('original') + r'}'
	substString = insString + delString
	return substString


def additionProcess(group_object):
	addString = ''
	
	# Is there a new paragraph followed by new text
	if group_object.group('value').startswith('\n\n') and group_object.group('value') != '\n\n':
		addString = '\n\n' + r'\added{\P' + group_object.group('value')
		addString = addString +  r'}'
		
	# Is the addition just a single new paragraph
	elif group_object.group('value') == '\n\n':
		addString = '\n\n' + r'\added{\P}'
		
	# Is it added text followed by a new paragraph?
	elif group_object.group('value').endswith('\n\n') and group_object.group('value') != '\n\n':
		addString = r'\added{' + group_object.group('value') + r'}'
		addString = addString + '\n\n' + r'\added{\P}' + '  \n'
		
	else:
		addString = r'\added{' + group_object.group('value') + r'}'
		
	return addString


def highlightProcess(group_object):
	replaceString = r'\hl{' + group_object.group('value') + r'} \tinytodo{' + group_object.group('comment') + '}'
	return replaceString


def commentProcess(group_object):
	replaceString = r' \tinytodo{' + group_object.group('value') + '}'
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

parser = argparse.ArgumentParser(description='Convert Critic Markup to LaTeX')
parser.add_argument('source', help='The source file path, including file name')
parser.add_argument('-o','--output', 
					help='Path to store the output file, including file name', 
					metavar='out-file', type=argparse.FileType('wt'), 
					required=False)
					
# parser.add_argument('-m2', 
#						help='Use the markdown2 python module. If left blank\ 
# 							then markdown module is used', 
#						action='store_true')
# parser.add_argument('-css','--css', 
# 						help='Path to a custom CSS file, including file name', 
# 						metavar='in-file', 
# 						type=argparse.FileType('rt'), 
# 						required=False)
# parser.add_argument('-b', '--browser', 
# 						help='View the output file in the default browser \
#							after saving.', 
# 						action='store_true')

args = parser.parse_args()
try:
	
	if args.source:
		inputFile = open(args.source, "r")
		inputText = inputFile.read()
		inputFile.close()
	else:
		log("No source file specified")
		print("No source file specified")
		sys.exit(1)
	
	h = inputText

	h = re.sub(del_pattern, deletionProcess, inputText, flags=re.DOTALL)

	h = re.sub(add_pattern, additionProcess, h, flags=re.DOTALL)

	h = re.sub(hl_pattern, highlightProcess, h, flags=re.DOTALL)

	# comment processing must come after highlights
	h = re.sub(comm_pattern, commentProcess, h, flags=re.DOTALL)

	h = re.sub(subs_pattern, subsProcess, h, flags=re.DOTALL)

	# if (args.m2):
	# 	import markdown2
	# 	h = markdown2.markdown(h, extras=['footnotes', 'fenced-code-blocks', 'cuddled-lists', 'code-friendly'])
	# 	print '\nUsing the Markdown2 module for processing'
	# else:
	# 	import markdown
	# 	h = markdown.markdown(h, extensions=['extra', 'codehilite', 'meta'])

	# Make temp LaTeX file to feed into Pandoc
	sourcepath = os.path.abspath(args.source)
	path, filename = os.path.split(sourcepath)
	tmpfile = path +'/'+'tmp_critic.md'
	file = open(tmpfile, 'w')
	file.write(h)
	file.close()


	# If an output file is specified, write to it
	if args.output:
		filesource = args.output
		abs_path = os.path.abspath(filesource.name)
		output_file = abs_path
	else:
		print("Converting >> " + args.source)
		output_file = path+'/'+filename.split(os.extsep, 1)[0]+'_graded.pdf'
		
	

#	Old output writing block
	# If an output file is specified, write to it
	# sourcepath = os.path.abspath(args.source)
	# if args.output:
	# 	filesource = args.output
	# 	abs_path = os.path.abspath(filesource.name)
	# 	output_file = abs_path
	# 	print(output_file)
	# 	#file = open(filename, 'wb')
	# 	filesource.write(h)
	# 	filesource.close()
	# 	print("\nOutput file created:  ", abs_path)
	# else:
	# 	path, filename = os.path.split(sourcepath)
	# 	print("Converting >> " + args.source)
	# 	output_file = path +'/'+filename.split(os.extsep, 1)[0]+'_CriticParseOut.tex'
	# 	file = open(output_file, 'w')
	# 	file.write(h)
	# 	file.close()
	# 	print("\nOutput file created:  " + output_file)
	

	import pypandoc as pd
	h = pd.convert_file(tmpfile,
						format='markdown+yaml_metadata_block',
						to='pdf',
						outputfile=output_file,
						extra_args=["--template", 
							"/Users/mskblackbelt/.pandoc/critic_grading.latex"])
						
except:
	print("Unexpected Error: ", sys.exc_info()[0])
	raise