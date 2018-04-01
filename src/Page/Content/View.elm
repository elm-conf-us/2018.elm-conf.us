module Page.Content.View exposing (root)

import App exposing (Msg)
import Html.Styled as Html exposing (Attribute, Html)
import Page.Content
    exposing
        ( Content(..)
        , EmphasisAmount(..)
        , Level(..)
        , Ordering(..)
        , Root(Root)
        )
import Route
import View.Elements as Elements


root : Root -> Html Msg
root (Root children) =
    Html.main_ [] (List.map content children)


content : Content -> Html Msg
content node =
    case node of
        Heading First children ->
            Html.h1 [] (List.map content children)

        Heading Second children ->
            Html.h2 [] (List.map content children)

        SemanticBreak ->
            Html.hr [] []

        ListParent Unordered children ->
            Html.ul [] (List.map content children)

        ListParent Ordered children ->
            Html.ol [] (List.map content children)

        ListItem children ->
            Html.li [] (List.map content children)

        Paragraph children ->
            Html.p [] (List.map content children)

        Link href children ->
            Elements.link (Route.lookup href) [] (List.map content children)

        Text stuff ->
            Html.text stuff

        Emphasized Regular children ->
            Html.em [] (List.map content children)

        Emphasized Strong children ->
            Html.strong [] (List.map content children)
