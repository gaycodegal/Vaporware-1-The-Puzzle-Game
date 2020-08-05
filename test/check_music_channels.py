"""Check music is assigned to a valid channel across many files"""

import argparse
import json
import tres_parse
import file_io
import sys

def test(inp_file):
    error_nodes = []
    nodes = tres_parse.parse_file(inp_file)
    nodes = tres_parse.filter_attribute(nodes, "type", "AudioStreamPlayer")
    for node in nodes:
        ok = False
        for line in node["lines"]:
            if line.startswith("bus") and tres_parse.line_val(line) != "Master":
                ok = True
        if not ok:
            error_nodes.append(node)
    if error_nodes:
        print("Found nodes with no, or bad bus selection:\n")
        print(json.dumps(list(error_nodes), sort_keys=True, indent=4))
        print("\n")
        return False
    return True

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    file_io.add_args(parser)
    args = parser.parse_args()
    with file_io.in_handle_open(args) as inp:
        if not test(inp):
            sys.exit(1)
