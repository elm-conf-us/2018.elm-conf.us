module View.Elements.Events exposing (onClickPreventDefaultForLinkWithHref)

import Html.Styled as Html
import Html.Styled.Events as Events
import Json.Decode


onClickPreventDefaultForLinkWithHref : msg -> Html.Attribute msg
onClickPreventDefaultForLinkWithHref msg =
    let
        isSpecialClick : Json.Decode.Decoder Bool
        isSpecialClick =
            Json.Decode.map2
                (\isCtrl isMeta -> isCtrl || isMeta)
                (Json.Decode.field "ctrlKey" Json.Decode.bool)
                (Json.Decode.field "metaKey" Json.Decode.bool)

        succeedIfFalse : a -> Bool -> Json.Decode.Decoder a
        succeedIfFalse msg preventDefault =
            case preventDefault of
                False ->
                    Json.Decode.succeed msg

                True ->
                    Json.Decode.fail "succeedIfFalse: condition was True"
    in
    Events.onWithOptions "click"
        { stopPropagation = False
        , preventDefault = True
        }
        (isSpecialClick
            |> Json.Decode.andThen (succeedIfFalse msg)
        )
