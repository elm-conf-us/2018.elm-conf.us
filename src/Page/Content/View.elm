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
import Styles.Elements as SElements
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

        Heading Third children ->
            Html.h3 [ Text.h3 ] (List.map content children)

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
            Html.em [ Text.em ] (List.map content children)

        Emphasized Strong children ->
            Html.strong [ Text.strong ] (List.map content children)

        Code children ->
            Html.code [ Text.code ] (List.map content children)

        Table children ->
            Html.table [ SElements.fillWidth ] (List.map content children)

        TableHead children ->
            Html.thead [] (List.map content children)

        TableBody children ->
            Html.tbody [] (List.map content children)

        TableRow children ->
            Html.tr [] (List.map content children)

        TableHeadCell children ->
            Html.th [ Text.strong ] (List.map content children)

        TableCell children ->
            Html.td [] (List.map content children)
