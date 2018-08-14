module Styles.Elements
    exposing
        ( ghostButton
        , small
        , strikethrough
        , table
        , tableCell
        , tableHead
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


tableHead : Attribute msg
tableHead =
    css
        [ color Colors.peach
        , borderBottom3 (px 1) solid Colors.peach
        ]


tableCell : Attribute msg
tableCell =
    css
        [ padding (px 10)
        , fontFeatureSettingsList
            [ featureTag "tnum"
            , featureTag "zero"
            ]
        ]


strikethrough : Attribute msg
strikethrough =
    css [ textDecoration lineThrough ]


small : Attribute msg
small =
    css [ fontSize (Text.scale 1.5) ]
