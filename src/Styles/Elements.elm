module Styles.Elements
    exposing
        ( ghostButton
        , table
        , tableCell
        )

import Css exposing (..)
import Html.Styled exposing (Attribute)
import Html.Styled.Attributes exposing (css)
import Styles.Colors as Colors
import Styles.Text as Text


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


table : Attribute msg
table =
    css
        [ marginBottom (Text.scale 1)
        , width (pct 100)
        ]


tableCell : Attribute msg
tableCell =
    css
        [ padding (Text.scale 0)
        , fontFeatureSettingsList
            [ featureTag "tnum"
            , featureTag "zero"
            ]
        ]
