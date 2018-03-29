module View.Elements exposing (container)

import Css exposing (..)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attributes


container : List (Html msg) -> Html msg
container =
    Html.div [ Attributes.css [] ]
