module Styles.Breakpoints exposing (belowFullSize, belowWideColumnSize)

import Css exposing (Style, px)
import Css.Media exposing (..)
import Styles.Text exposing (fullSize, wideColumnSize)


belowFullSize : List Style -> Style
belowFullSize =
    withMedia [ only screen [ maxWidth fullSize ] ]


belowWideColumnSize : List Style -> Style
belowWideColumnSize =
    withMedia [ only screen [ maxWidth wideColumnSize ] ]
