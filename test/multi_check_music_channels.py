"""Check music is assigned to a valid channel across many files"""

import argparse
import json
import check_music_channels
import file_io
import sys

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("inputs", nargs="+")
    args = parser.parse_args()
    bad = False
    for inp in args.inputs:
        print("testing", inp)
        with file_io.read_handle_open(inp) as input_file:
            if not check_music_channels.test(input_file):
                bad = True
    if bad:
        sys.exit(1)

