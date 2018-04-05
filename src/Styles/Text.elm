module Styles.Text
    exposing
        ( a
        , aReversed
        , aReversedInline
        , body
        , em
        , fullSize
        , h1
        , h2
        , h2Reversed
        , hero
        , li
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
import Styles.Colors as Colors


scale : Float -> Rem
scale place =
    let
        ratio =
            1.414
    in
    ratio ^ (place - 1) |> Css.rem


fullSize : Px
fullSize =
    px 900


wideColumnSize : Px
wideColumnSize =
    px 636


body : Html msg
body =
    Foreign.global
        [ Foreign.html
            [ fontSize (px 18)
            , fontFamilies [ "Vollkorn", serif.value ]
            , color Colors.black
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
        ]


h2 : Attribute msg
h2 =
    css
        [ baseHeader
        , fontSize <| scale 2
        , lineHeight <| scale 3
        , marginBottom <| scale 0.5
        , marginTop <| scale 2
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
        ]



-- H3 is Vollkorn at regular text size, but semibold (600 weight)


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
