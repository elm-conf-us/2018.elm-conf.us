module Styles.Elements exposing (ghostButton)

import Css exposing (..)
import Html.Styled exposing (Attribute)
import Html.Styled.Attributes exposing (css)
import Styles.Colors as Colors


ghostButton : Attribute msg
ghostButton =
    css
        [ padding2 (px 10) (px 30)
        , color Colors.white
        , border3 (px 1) solid Colors.white
        , borderRadius (px 4)
        , hover [ textDecoration none ]
        , backgroundColor Colors.ghostlyWhite
        ]
