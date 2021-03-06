module Styles.Text
    exposing
        ( a
        , aReversed
        , aReversedInline
        , align
        , body
        , code
        , em
        , fullSize
        , h1
        , h2
        , h2Reversed
        , h3
        , hero
        , li
        , narrowColumnSize
        , ol
        , p
        , scale
        , strong
        , ul
        , wideColumnSize
        )

{-| These are separated from regular styles to:

1.  keep the modular ratio math all in one place to make it easy to work with the
    scales.
2.  expose the styles of headers and such without tying those styles to
    semantics. So for example, we might need a h2 with an h1's style. That's
    possible now!

-}

import Css exposing (..)
import Css.Foreign as Foreign
import Html.Styled exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Page.Content exposing (Alignment(..))
import Styles.Colors as Colors


scale : Float -> Rem
scale place =
    let
        ratio =
            1.414
    in
    ratio ^ (place - 1) |> Css.rem


fullSize : Rem
fullSize =
    Css.rem 50


wideColumnSize : Rem
wideColumnSize =
    Css.rem 35


narrowColumnSize : Rem
narrowColumnSize =
    fullSize |-| wideColumnSize


body : Html msg
body =
    Foreign.global
        [ Foreign.html
            [ fontSize (px 18)
            , fontFamilies [ "Vollkorn", serif.value ]
            , color Colors.black
            , boxSizing borderBox
            ]
        ]


baseHeader : Style
baseHeader =
    Css.batch
        [ fontFamilies [ "Josefin Sans", sansSerif.value ]
        , color Colors.peach
        ]


h1 : Attribute msg
h1 =
    css
        [ baseHeader
        , fontSize <| scale 3
        , lineHeight <| scale 4
        , marginBottom <| scale 0.5
        , marginTop <| scale 2
        , firstChild [ marginTop zero ]
        ]


h2 : Attribute msg
h2 =
    css
        [ baseHeader
        , fontSize <| scale 2
        , lineHeight <| scale 3
        , marginBottom <| scale 0.5
        , marginTop <| scale 2
        , firstChild [ marginTop zero ]
        ]


h2Reversed : Attribute msg
h2Reversed =
    css
        [ baseHeader
        , color Colors.white
        , fontSize <| scale 2
        , lineHeight <| scale 3
        , marginBottom <| scale 0.5
        , marginTop <| scale 2
        , firstChild [ marginTop zero ]
        ]


h3 : Attribute msg
h3 =
    css
        [ baseText
        , fontWeight (int 600)
        , marginBottom <| scale 1
        ]


baseText : Style
baseText =
    Css.batch
        [ fontSize <| scale 1
        , lineHeight <| scale 2
        ]


p : Attribute msg
p =
    css
        [ baseText
        , marginBottom <| scale 1
        ]


baseList : Style
baseList =
    Css.batch
        [ paddingLeft <| scale 1
        , paddingRight <| scale 1
        ]


ul : Attribute msg
ul =
    css
        [ baseList
        , listStyle disc
        , marginBottom <| scale 1
        ]


ol : Attribute msg
ol =
    css
        [ baseList
        , listStyle decimal
        , marginBottom <| scale 1
        ]


li : Attribute msg
li =
    css [ baseText ]


baseLink : Style
baseLink =
    Css.batch
        [ baseText
        , textDecoration none
        , hover [ textDecoration underline ]
        ]


a : Attribute msg
a =
    css
        [ baseLink
        , color Colors.peach
        ]


aReversed : Attribute msg
aReversed =
    css
        [ baseLink
        , color Colors.white
        ]


aReversedInline : Attribute msg
aReversedInline =
    css
        [ baseLink
        , color Colors.white
        , textDecoration underline
        ]


hero : Attribute msg
hero =
    css
        [ fontSize <| scale 3
        , lineHeight <| scale 4
        , textAlign center
        , color Colors.white
        ]


em : Attribute msg
em =
    css [ fontStyle italic ]


strong : Attribute msg
strong =
    css [ fontWeight (int 600) ]


code : Attribute msg
code =
    css
        [ fontFamily monospace
        , fontSize (Css.rem 0.9)
        ]


align : Alignment -> Attribute msg
align alignment =
    css <|
        case alignment of
            Left ->
                [ textAlign left ]

            Center ->
                [ textAlign center ]

            Right ->
                [ textAlign right ]

            Unset ->
                []
