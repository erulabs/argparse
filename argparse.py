#!/usr/bin/env python

# Useage: argparse --which arguments -do="we" match

import sys


for x in sys.argv:
	if x == '--which':
	 	print('--which')
	elif x == 'arguments':
	    print('arguments')
	elif x == '-do="we"':
	    print('-do="we"')
	elif x == 'match':
	    print('match')
	else:
	    print('no matching args found')
	print 'arg is ', x 

print 'Number of arguments:', len(sys.argv), 'arguments.'
print 'Argument List:', str(sys.argv)