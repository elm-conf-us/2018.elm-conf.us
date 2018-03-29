#!/usr/bin/env python
from __future__ import unicode_literals, print_function
import argparse
import sys
import os.path


def remove_prefix(prefix, paths):
    return [path[len(prefix):] for path in paths]


def camelize(name):
    segments = name.split('-')

    return ''.join(
        [segments[0]] + [segment.capitalize() for segment in segments[1:]]
    )


LOOKUP = '''\
module {name} exposing (Route(..), lookup, parser, {exposing})

import Dict exposing (Dict)
import Navigation
import UrlParser exposing ((</>), map, s, top)


type Route
    = Internal {{ json : String, html : String }}
    | External String


lookup : String -> Route
lookup route =
    Dict.get route routes |> Maybe.withDefault (External route)


parser : Navigation.Location -> Maybe Route
parser location =
    let
        selector =
            UrlParser.oneOf
                [ {parsers}
                ]
    in
    UrlParser.parsePath selector location


routes : Dict String Route
routes =
    Dict.fromList
        [ {lookups}
        ]
{routes}
'''

ROUTE = '''\


{name} : Route
{name} =
    {body}
'''


def lookup(args):
    sources = remove_prefix('content/', args.sources)
    jsons = [path for path in remove_prefix('public', args.jsons)]
    htmls = [
        os.path.dirname(path) for path in remove_prefix('public', args.htmls)
    ]

    identifiers = [
        camelize(os.path.splitext(source)[0])
        for source in sources
    ]

    routes = ''.join(
        ROUTE.format(
            name=identifier,
            body='Internal {{ json = "{}", html = "{}" }}'.format(json, html)
        )
        for (identifier, json, html)
        in zip(identifiers, jsons, htmls)
    )

    lookups = [
        '( "{0}", {1} )'.format(*item)
        for item in zip(sources, identifiers)
    ]

    parsers = sorted(
        [
            'map {0} ({1})'.format(
                identifier,
                ' </> '.join(
                    's "{}"'.format(segment)
                    for segment in html.split('/')
                    if segment != ''
                ) or 'top',
            )
            for (identifier, html)
            in zip(identifiers, htmls)
        ],
        # higher-up routes will be shorter. They use `top`, which doesn't
        # consume, so they'll need to go first.
        key=len,
    )

    return write_if_changed(
        args.output_if_changed,
        LOOKUP.format(
            name=args.module_name,
            parsers='\n                , '.join(parsers),
            lookups='\n        , '.join(lookups),
            routes=routes,
            exposing=', '.join(identifiers)
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
