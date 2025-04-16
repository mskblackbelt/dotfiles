#!/usr/bin/python
# -*- coding: UTF-8 -*-

from sys import stdin, stdout

blocks = u'▁▂▃▄▅▆▇██'

def spark(data):
  line = ''
  lo = float(min(data))
  hi = float(max(data))
  incr = (hi - lo)/8
  for n in data:
    line += blocks[int((float(n) - lo)/incr)]
  return line

stdout.write(spark([float(x) for x in stdin.read().split()]).encode('utf8'))