"""Convert tres file to json"""

import json
import argparse
import file_io

def parse_file(tres):
    parsed = []
    node = None
    for line in tres:
        line = line.strip()
        if len(line) == 0:
            continue
        if is_new_node(line):
            node = parse_node(line)
            parsed.append(node)
        elif node is not None:
            node["lines"].append(line)
    return parsed
            
def is_new_node(line):
    return line[0] == "["

def parse_node(line):
    #line = line.replace("( ", "(").replace(" )", ")")
    line = line.strip("[]").split(" ", 1)
    node = {"lines": [], "type": "", "attributes": {}}
    if len(line) == 0:
        raise Error("bad line", line)
    node["type"] = line[0]
    if len(line) == 1:
        return node

    # too much logic for one liner
    line = line[1].split("=")
    name = line[0]
    pairs = []
    for i in range(1, len(line)):
        rest = line[i].rsplit(" ", 1)
        if len(rest) > 1:
            next_name = rest[1]
        rest = rest[0]

        if rest == "" or (rest[0] != '"' and " " in rest):
            rest = '"%s"' % rest
        l = '"%s": %s' % (name, rest)
        pairs.append(l)
        name = next_name
    
    attrs = "{%s}" % (", ".join(pairs))
    node["attributes"] = json.loads(attrs)
    return node

def line_val(line):
    return line.split("=", 1)[1].strip()

def filter_type(nodes, type):
    return filter(lambda n: n["type"] == type, nodes)

def filter_attribute(nodes, attr, value):
    return filter(lambda n: n["attributes"].get(attr, False) == value, nodes)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    file_io.add_args(parser)
    args = parser.parse_args()
    with file_io.in_handle_open(args) as inp, file_io.out_handle_open(args) as out:
        parsed = parse_file(inp)
        out.write(json.dumps(parsed, sort_keys=True, indent=4))
