module View.Footer exposing (footer)

import App exposing (Msg)
import Css exposing (..)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attributes exposing (css)
import Route
import Styles.Breakpoints as Breakpoints
import Styles.Colors as Colors
import Styles.Text as Text
import View.Elements as Elements


footer : Html Msg
footer =
    Html.div [] [ {- spacer -} sections ]


sections : Html Msg
sections =
    Html.div
        [ css
            [ backgroundImage <|
                linearGradient
                    (stop Colors.peach)
                    (stop Colors.orange)
                    []
            , marginTop <| Text.scale 5
            ]
        ]
        [ Elements.spacer 5
        , Html.footer
            [ css
                [ displayFlex
                , maxWidth Text.fullSize
                , margin2 zero auto
                , color Colors.white
                , Breakpoints.belowFullSize
                    [ padding2 zero <| Text.scale 1
                    , flexDirection column
                    ]
                ]
            ]
            [ section "Mailing List"
                [ Html.text "Tickets yada yada yada" ]
            , section "Sponsorships"
                [ Html.text "Sponsorships are available for elm-conf 2018 at a variety of levels. Download "
                , Elements.link
                    (Route.External "TODO")
                    [ Text.aReversedInline ]
                    [ Html.text "our prospectus" ]
                , Html.text " or "
                , Elements.link
                    (Route.External "mailto:elm-conf@thestrangeloop.com")
                    [ Text.aReversedInline ]
                    [ Html.text "email elm-conf@thestrangeloop.com" ]
                , Html.text " for more information."
                ]
            , section "Contact"
                [ Html.text "lorem ipsum dolor sit amet pro consecorum del taco" ]
            , section "Code of Conduct"
                [ Html.text "Participation in elm-conf is governed by the "
                , Elements.link
                    (Route.External "https://thestrangeloop.com/policies.html")
                    [ Text.aReversedInline ]
                    [ Html.text "Strange Loop Code of Conduct" ]
                , Html.text "."
                ]
            ]
        , Elements.spacer 5
        ]


section : String -> List (Html Msg) -> Html Msg
section title contents =
    Html.section
        [ css
            [ flexGrow <| int 1
            , flexBasis <| px 0
            , marginRight <| Text.scale 1
            , lastChild [ marginRight zero ]
            ]
        ]
        [ Html.h2
            [ Text.h2Reversed ]
            [ Html.text title ]
        , Html.p
            [ Text.p ]
            contents
        ]
