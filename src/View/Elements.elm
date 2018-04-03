module View.Elements
    exposing
        ( container
        , link
        , linkGhostButton
        , nav
        , spacer
        )

import App exposing (Msg(..))
import Css
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attributes exposing (css)
import Html.Styled.Events as Events exposing (defaultOptions)
import Json.Decode exposing (succeed)
import Route exposing (Route)
import Styles.Colors as Colors
import Styles.Text as Text


container : List (Html Msg) -> Html Msg
container stuff =
    Html.div [] (Text.body :: stuff)


nav : List ( String, Route ) -> Html Msg
nav routes =
    Html.nav
        []
        (List.map (\( name, route ) -> navLink name route) routes)


navLink : String -> Route -> Html Msg
navLink caption route =
    link route [] [ Html.text caption ]


link : Route -> List (Attribute Msg) -> List (Html Msg) -> Html Msg
link route base children =
    let
        destination =
            case route of
                Route.Internal { html } ->
                    [ Attributes.href html
                    , Events.onWithOptions "click"
                        -- TODO: this is blocking cmd-click
                        { stopPropagation = True
                        , preventDefault = True
                        }
                        (succeed <| GoTo route)
                    ]

                Route.External html ->
                    [ Attributes.href html ]
    in
    Html.a (destination ++ base) children


linkGhostButton : Route -> List (Attribute Msg) -> List (Html Msg) -> Html Msg
linkGhostButton route base children =
    link
        route
        (css
            [ Css.padding2 (Css.px 10) (Css.px 30)
            , Css.color Colors.white
            , Css.border3 (Css.px 1) Css.solid Colors.white
            , Css.borderRadius (Css.px 4)
            , Css.hover [ Css.textDecoration Css.none ]
            , Css.backgroundColor Colors.ghostlyWhite
            ]
            :: base
        )
        children


spacer : Float -> Html msg
spacer scale =
    Html.div [ css [ Css.height <| Text.scale scale ] ] []
