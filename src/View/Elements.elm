module View.Elements
    exposing
        ( container
        , header
        , link
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


header : List ( String, Route ) -> Html Msg
header routes =
    Html.nav
        []
        (List.map (\( name, route ) -> headerLink name route) routes)


headerLink : String -> Route -> Html Msg
headerLink caption route =
    link route [] [ Html.text caption ]


link : Route -> List (Attribute Msg) -> List (Html Msg) -> Html Msg
link route base children =
    let
        destination =
            case route of
                Route.Internal { html } ->
                    [ Attributes.href html
                    , Events.onWithOptions "click"
                        { stopPropagation = True
                        , preventDefault = True
                        }
                        (succeed <| GoTo route)
                    ]

                Route.External html ->
                    [ Attributes.href html ]
    in
    Html.a (destination ++ base) children
