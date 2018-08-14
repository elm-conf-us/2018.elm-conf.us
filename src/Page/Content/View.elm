module Page.Content.View exposing (root)

import App exposing (Msg)
import Html.Styled as Html exposing (Attribute, Html)
import Page exposing (FrontMatter, Page)
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


root : Page -> Html Msg
root ({ frontMatter } as page) =
    case page.content of
        Page.Single root ->
            single frontMatter root

        Page.Section pages ->
            pages
                |> List.map readMore
                |> List.map insertTitleAsHeading
                |> List.map reduceHeadings
                |> List.map root
                |> Html.div []


single : FrontMatter -> Root -> Html Msg
single { image, title } (Root children) =
    case image of
        Just image ->
            Elements.sectionWithImage
                (Elements.Image image.source title image.round)
                (List.map content children)

        Nothing ->
            Elements.section
                (List.map content children)


{-| this really only makes sense for single pages
-}
insertTitleAsHeading : Page -> Page
insertTitleAsHeading ({ frontMatter } as page) =
    let
        time =
            case frontMatter.time of
                Just when ->
                    Small [ Text when, Text ": " ]

                Nothing ->
                    Text ""
    in
    case page.content of
        Page.Single (Root children) ->
            { page | content = Page.Single <| Root <| Heading First [ time, Text frontMatter.title ] :: children }

        _ ->
            page


reduceHeadings : Page -> Page
reduceHeadings page =
    let
        reduceHeadingsContent : Content -> Content
        reduceHeadingsContent content =
            case content of
                Heading First children ->
                    Heading Second children

                Heading Second children ->
                    Heading Third children

                _ ->
                    content
    in
    case page.content of
        Page.Single (Root children) ->
            { page | content = Page.Single <| Root <| List.map reduceHeadingsContent children }

        Page.Section pages ->
            { page | content = Page.Section (List.map reduceHeadings pages) }


readMore : Page -> Page
readMore page =
    let
        link caption =
            page
                |> Page.mapSource
                    (\source -> [ Link source caption ])
                |> Maybe.withDefault []

        untilMore contents =
            case contents of
                (Paragraph [ Link "directive:more" caption ]) :: _ ->
                    link caption

                el :: els ->
                    el :: untilMore els

                [] ->
                    []
    in
    case page.content of
        Page.Single (Root children) ->
            { page | content = Page.Single <| Root <| untilMore children }

        Page.Section pages ->
            { page | content = Page.Section (List.map readMore pages) }


content : Content -> Html Msg
content node =
    case node of
        -- directives
        Paragraph [ Text "!!more" ] ->
            Html.text ""

        -- everything else
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

        Link "directive:more" children ->
            Html.text ""

        Link "directive:youtube" [ Text id ] ->
            Elements.youtube id

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
            Html.table [ SElements.table ] (List.map content children)

        TableHead children ->
            Html.thead [ SElements.tableHead ] (List.map content children)

        TableBody children ->
            Html.tbody [] (List.map content children)

        TableRow children ->
            Html.tr [] (List.map content children)

        TableHeadCell alignment children ->
            Html.th
                [ SElements.tableCell
                , Text.strong
                , Text.align alignment
                ]
                (List.map content children)

        TableCell alignment children ->
            Html.td
                [ SElements.tableCell
                , Text.align alignment
                ]
                (List.map content children)

        Deleted children ->
            Html.span
                [ SElements.strikethrough ]
                (List.map content children)

        Small children ->
            Html.small
                [ SElements.small ]
                (List.map content children)
