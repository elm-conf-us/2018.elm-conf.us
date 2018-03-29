module View exposing (view)

import Html.Styled as Html exposing (Html)
import Page exposing (Page)
import Page.Content.View exposing (root)
import View.Elements as Elements


view : Result String Page -> Html msg
view res =
    case res of
        Ok { content } ->
            Elements.container [ root content ]

        Err err ->
            Html.text err
