module Page.Content.View exposing (root)

import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attributes
import Page.Content
    exposing
        ( Content(..)
        , EmphasisAmount(..)
        , Level(..)
        , Ordering(..)
        , Root(Root)
        )


root : Root -> Html msg
root (Root children) =
    Html.main_ [] (List.map content children)


content : Content -> Html msg
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
            Html.a [ Attributes.href href ] (List.map content children)

        Text stuff ->
            Html.text stuff

        Emphasized Regular children ->
            Html.em [] (List.map content children)

        Emphasized Strong children ->
            Html.strong [] (List.map content children)
