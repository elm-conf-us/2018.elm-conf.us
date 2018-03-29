module View exposing (view)

import Html.Styled as Html exposing (Html)
import Page exposing (Page)
import Page.Content.View exposing (root)


view : Result String Page -> Html msg
view res =
    case res of
        Ok { content } ->
            root content

        Err err ->
            Html.text err
