module View.Footer exposing (footer)

import App exposing (Msg)
import Css exposing (..)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attributes exposing (css)
import Route
import Styles.Breakpoints as Breakpoints
import Styles.Colors as Colors
import Styles.Elements as SElements
import Styles.Text as Text
import View.Elements as Elements
import View.Waves exposing (waves)


footer : Html Msg
footer =
    Html.div [] [ {- spacer -} sections ]


sections : Html Msg
sections =
    Html.div
        []
        [ Elements.spacer 6
        , waves "footer" "rgba(255,95,109,0.8)"
        , Html.div
            [ css
                [ backgroundImage <|
                    linearGradient
                        (stop Colors.peach)
                        (stop Colors.orange)
                        []
                ]
            ]
            [ Html.footer
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
                    [ Html.p [ Text.p ] [ Html.text "Be the first to know CFP dates, when speakers are announced, and when tickets go on sale!" ]
                    , Html.form
                        [ Attributes.action "https://elm-conf.us4.list-manage.com/subscribe/post?u=fa7fac034558813ada05778e6&amp;id=891ea3a34d"
                        , Attributes.method "post"
                        ]
                        [ Html.input
                            [ Text.p
                            , css
                                [ display inlineBlock
                                , fontSize (Css.rem 0.8) |> important
                                , padding2 (px 10) zero
                                , width (pct 100)
                                , textAlign center
                                , border zero
                                , borderRadius (px 4)
                                ]
                            , Attributes.type_ "email"
                            , Attributes.name "EMAIL"
                            , Attributes.placeholder "you@coolperson.com"
                            ]
                            []
                        , Html.input
                            [ SElements.ghostButton
                            , Text.p
                            , css [ width (pct 100) ]
                            , Attributes.type_ "submit"
                            , Attributes.name "subscribe"
                            , Attributes.value "Let me know!"
                            ]
                            []
                        ]
                    ]
                , section "Sponsorships"
                    [ Html.text "Sponsorships are available for elm-conf 2018 at a variety of levels. Email "
                    , Elements.link
                        (Route.External "mailto:elm-conf@thestrangeloop.com")
                        [ Text.aReversedInline ]
                        [ Html.text "elm-conf@thestrangeloop.com" ]
                    , Html.text " for more information."
                    ]
                , section "Contact"
                    [ Html.ul [ Text.ul ]
                        [ Html.li []
                            [ Elements.link
                                (Route.External "mailto:elm-conf@thestrangeloop.com")
                                [ Text.aReversedInline ]
                                [ Html.text "Email" ]
                            ]
                        , Html.li []
                            [ Elements.link
                                (Route.External "https://twitter.com/elmconf")
                                [ Text.aReversedInline ]
                                [ Html.text "Twitter" ]
                            ]
                        , Html.li []
                            [ Elements.link
                                (Route.External "https://mastodon.technology/@elmconf")
                                [ Text.aReversedInline ]
                                [ Html.text "Mastodon" ]
                            ]
                        , Html.li []
                            [ Elements.link
                                (Route.External "https://2017.elm-conf.us")
                                [ Text.aReversedInline ]
                                [ Html.text "2017 site" ]
                            ]
                        , Html.li []
                            [ Elements.link
                                (Route.External "https://2016.elm-conf.us")
                                [ Text.aReversedInline ]
                                [ Html.text "2016 site" ]
                            ]
                        ]
                    ]
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
