module View.Elements
    exposing
        ( container
        , link
        , nav
        )

import App exposing (Msg(..))
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events exposing (defaultOptions)
import Json.Decode exposing (succeed)
import Route exposing (Route)


container : List (Html Msg) -> Html Msg
container =
    Html.div [ Attributes.css [] ]


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
