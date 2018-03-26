#!/usr/bin/env python
from __future__ import unicode_literals, print_function
import argparse
import sys
import os.path


def remove_prefix(prefix, paths):
    return [path[len(prefix):] for path in paths]


def list_of_tuples_elm(lot):
    items = [
        '( "{}", "{}" )'.format(one, two)
        for (one, two)
        in lot
    ]
    return '[ ' + ', '.join(items) + ' ]'


LOOKUP = '''\
module {} exposing (human, json)

import Dict exposing (Dict)


toHuman : Dict String String
toHuman =
    Dict.fromList {}


human : String -> Maybe String
human markdown =
    Dict.get markdown toHuman


toJson : Dict String String
toJson =
    Dict.fromList {}


json : String -> Maybe String
json markdown =
    Dict.get markdown toJson
'''


def lookup(args):
    sources = remove_prefix('content/', args.sources)
    jsons = [path for path in remove_prefix('public', args.jsons)]
    htmls = [
        os.path.dirname(path) for path in remove_prefix('public', args.htmls)
    ]

    to_json = zip(sources, jsons)
    to_human = zip(sources, htmls)

    return write_if_changed(
        args.output_if_changed,
        LOOKUP.format(
            args.module_name,
            list_of_tuples_elm(to_human),
            list_of_tuples_elm(to_json),
        )
    )


def write_if_changed(path, contents):
    # prevent unnecessary recompilation
    try:
        old = open(path, 'r').read()
    except IOError:
        old = ''

    if contents != old:
        with open(path, 'w') as fh:
            fh.write(contents)

        print("wrote {}".format(path), file=sys.stderr)
    else:
        print(
            "not replacing {}, it hasn't changed".format(path),
            file=sys.stderr,
        )

    return 0


def main(args):
    if args.mode == 'lookup':
        return lookup(args)

    return 1


if __name__ == '__main__':
    parser = argparse.ArgumentParser(__file__)
    parser.add_argument('mode', choices=['lookup'])
    parser.add_argument('--sources', type=str.split)
    parser.add_argument('--jsons', type=str.split)
    parser.add_argument('--htmls', type=str.split)
    parser.add_argument('--module-name')
    parser.add_argument('--output-if-changed')

    sys.exit(main(parser.parse_args()))
