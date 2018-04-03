module Styles.Colors
    exposing
        ( black
        , ghostlyWhite
        , orange
        , peach
        , white
        )

import Css exposing (Color, hex, hsla)


orange : Color
orange =
    hex "FFC371"


peach : Color
peach =
    hex "FF5F6D"


white : Color
white =
    hex "FFFFFF"


ghostlyWhite : Color
ghostlyWhite =
    hsla 0 0 100 0.1


black : Color
black =
    hex "4A4A4A"
