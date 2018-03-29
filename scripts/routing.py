#!/usr/bin/env python
from __future__ import unicode_literals, print_function
import argparse
import sys
import os.path


def remove_prefix(prefix, paths):
    return [path[len(prefix):] for path in paths]


LOOKUP = '''\
module {} exposing (Route(..), lookup)

import Dict exposing (Dict)


type Route
    = Internal {{ json : String, html : String }}
    | External String


routes : Dict String Route
routes =
    Dict.fromList
        [ {}
        ]


lookup : String -> Route
lookup route =
    Dict.get route routes |> Maybe.withDefault (External route)
'''


def lookup(args):
    sources = remove_prefix('content/', args.sources)
    jsons = [path for path in remove_prefix('public', args.jsons)]
    htmls = [
        os.path.dirname(path) for path in remove_prefix('public', args.htmls)
    ]

    code = [
        '( "{}", Internal {{ html = "{}", json = "{}" }} )'.format(*item)
        for item in zip(sources, htmls, jsons)
    ]

    return write_if_changed(
        args.output_if_changed,
        LOOKUP.format(
            args.module_name,
            '\n        , '.join(code)
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
