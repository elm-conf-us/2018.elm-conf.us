#!/usr/bin/env python
from __future__ import print_function, unicode_literals
from argparse import ArgumentParser
import os
import os.path
import sys
import json


def main(args):
    pages = []

    for dirname, dirnames, filenames in os.walk(args.source):
        for filename in filenames:
            current = os.path.join(dirname, filename)

            if current == args.destination:
                continue

            if filename.endswith('.json'):
                with open(current, 'r') as fh:
                    pages.append(json.load(fh))

    out = {
        'type': 'section',
        'frontMatter': {
            'title': args.title or os.path.dirname(args.destination)
        },
        'pages': pages,
    }

    with open(args.destination, 'w') as fh:
        json.dump(out, fh, separators=(',', ':'))

    return 0


if __name__ == '__main__':
    parser = ArgumentParser(__file__)
    parser.add_argument('source')
    parser.add_argument('destination')
    parser.add_argument('--title', default=None)

    sys.exit(main(parser.parse_args()))
