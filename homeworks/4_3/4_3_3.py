#!/usr/bin/env python3
import json
import sys, os, json, yaml

#fname = sys.argv[1]
if len(sys.argv) > 1:
    fname = sys.argv[1]
    fsplit = (os.path.splitext(fname))
    if os.path.exists(fname):
        if fname.endswith('.json'):
            with open(fname, 'r') as f:
                try:
                    js = json.load(f)
                    with open(fsplit[0] + '.yml', 'w') as f_yml:
                        f_yml.write(yaml.dump(js))
                    print('File has been converted to YAML format')
                except json.decoder.JSONDecodeError:
                    print('File is not JSON format')
        elif fname.endswith('.yml'):
            with open(fname, 'r') as f:
                try:
                    ym = yaml.safe_load(f)
                    with open(fsplit[0] + '.json', 'w') as f_js:
                        f_js.write(json.dumps(ym, indent=2))
                    print('File has been converted to JSON format')
                except yaml.parser.ParserError:
                    print('File is not YAML format')

        else:
            print('File is not JSON or YAML')

    else:
        print('File not exist')

else:
    print('Enter file name')
