module Styles.Text
    exposing
        ( body
        , h1
        , h2
        , li
        , ol
        , p
        , ul
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


scale : Float -> Rem
scale place =
    let
        ratio =
            1.414
    in
    ratio ^ place |> Css.rem


body : Html msg
body =
    Foreign.global
        [ Foreign.body
            [ fontSize (px 18) -- TODO: this isn't sufficiently global
            , fontFamilies [ "Vollkorn", serif.value ]
            , color (hex "#4A4A4A")
            ]
        ]


h1 : Attribute msg
h1 =
    css
        [ fontSize <| scale 3
        , lineHeight <| scale 4
        ]


h2 : Attribute msg
h2 =
    css
        [ fontSize <| scale 2
        , lineHeight <| scale 3
        ]


p : Attribute msg
p =
    css
        [ fontSize <| scale 1
        , lineHeight <| scale 2
        , marginBottom <| scale 1
        ]


ul : Attribute msg
ul =
    css
        [ listStyle disc
        , paddingLeft <| scale 0.5
        , marginLeft <| scale 0.5
        , marginBottom <| scale 1
        ]


ol : Attribute msg
ol =
    css
        [ listStyle decimal
        , paddingLeft <| scale 0.5
        , marginLeft <| scale 0.5
        , marginBottom <| scale 1
        ]


li : Attribute msg
li =
    css
        [ fontSize <| scale 1
        , lineHeight <| scale 2
        ]
