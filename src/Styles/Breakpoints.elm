module Styles.Breakpoints
    exposing
        ( aboveFullSize
        , belowFullSize
        , belowWideColumnSize
        )

import Css exposing (Style, px)
import Css.Media exposing (..)
import Styles.Text exposing (fullSize, wideColumnSize)


aboveFullSize : List Style -> Style
aboveFullSize =
    withMedia [ only screen [ minWidth fullSize ] ]


belowFullSize : List Style -> Style
belowFullSize =
    withMedia [ only screen [ maxWidth fullSize ] ]


belowWideColumnSize : List Style -> Style
belowWideColumnSize =
    withMedia [ only screen [ maxWidth wideColumnSize ] ]
