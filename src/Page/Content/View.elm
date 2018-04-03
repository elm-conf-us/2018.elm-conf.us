module Page.Content.View exposing (root)

import App exposing (Msg)
import Css
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Page.Content
    exposing
        ( Content(..)
        , EmphasisAmount(..)
        , Level(..)
        , Ordering(..)
        , Root(Root)
        )
import Route
import Styles.Text as Text
import View.Elements as Elements


root : Root -> List (Html Msg)
root (Root children) =
    List.map content children


content : Content -> Html Msg
content node =
    case node of
        Heading First children ->
            Html.h1 [ Text.h1 ] (List.map content children)

        Heading Second children ->
            Html.h2 [ Text.h2 ] (List.map content children)

        SemanticBreak ->
            Html.hr [] []

        ListParent Unordered children ->
            Html.ul [ Text.ul ] (List.map content children)

        ListParent Ordered children ->
            Html.ol [ Text.ol ] (List.map content children)

        ListItem children ->
            Html.li [ Text.li ] (List.map content children)

        Paragraph children ->
            Html.p [ Text.p ] (List.map content children)

        Link href children ->
            Elements.link
                (Route.lookup href)
                [ Text.a ]
                (List.map content children)

        Text stuff ->
            Html.text stuff

        Emphasized Regular children ->
            Html.em [] (List.map content children)

        Emphasized Strong children ->
            Html.strong [] (List.map content children)
