import argparse
import sys

def add_args(parser):
    parser.add_argument('--input',
                        default="stdin",
                        help='input file (default: stdin)')
    parser.add_argument('--output',
                        default="stdout",
                        help='input file (default: stdout)')

def in_handle_open(args):
    return read_handle_open(args.input)

def read_handle_open(val):
    if val == "stdin":
        return sys.stdin
    return open(val, "r")

def out_handle_open(args):
    if args.output == "stdout":
        return sys.stdout
    return open(args.output, "w")
