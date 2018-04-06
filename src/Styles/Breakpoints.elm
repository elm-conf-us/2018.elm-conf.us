module Styles.Breakpoints exposing (belowFullSize)

import Css exposing (Style, px)
import Css.Media exposing (..)
import Styles.Text exposing (fullSize)


belowFullSize : List Style -> Style
belowFullSize =
    withMedia [ only screen [ maxWidth fullSize ] ]
