module View exposing (view)

{-| This module implement the `view` function for the game.


# Interface

@docs view

-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import List exposing (head)
import Maybe exposing (withDefault)
import Messages exposing (..)
import Model exposing (..)
import String exposing (fromFloat, fromInt, length, repeat, right)
import Svg exposing (Svg)
import Svg.Attributes as SvgAttr
import Update exposing (..)


{-| -}
view : Model -> Html Msg
view model =
    let
        initlife =
            case model.state of
                Stg level ->
                    case level of
                        1 ->
                            1000

                        2 ->
                            800

                        3 ->
                            1500

                        _ ->
                            1500

                _ ->
                    500
    in
    case model.state of
        Stg level ->
            div
                [ style "width" "100%"
                , style "height" "100%"
                , style "position" "absolute"
                , style "left" "0"
                , style "top" "0"
                , style "background" "black"
                , style "display" "flex"
                , style "align-items" "center"
                , style "justify-content" "center"
                ]
                [ playAudio ("assets/audio/boss" ++ fromInt level ++ ".ogg")
                , div
                    [ style "width" (fromInt canvasHeight ++ "px")
                    , style "height" (fromInt canvasHeight ++ "px")
                    , style "position" "fixed"
                    ]
                    [ img
                        [ src ("assets/img/bossbackground" ++ fromInt level ++ ".png")
                        , style "height" "100%"
                        , style "width" "100%"
                        , style "position" "absolute"
                        ]
                        []
                    , Svg.svg
                        [ SvgAttr.width (fromInt canvasWidth)
                        , SvgAttr.height (fromInt canvasHeight)
                        , style "position" "absolute"
                        , style "background" "rgba(0,0,0,0)"
                        ]
                        (viewCharacter model.character
                            ++ List.map viewBullet model.bullets
                            ++ [ viewEnemy level model.enemy ]
                        )
                    , Svg.svg
                        [ SvgAttr.width "240"
                        , SvgAttr.height "720"
                        , style "left" "480px"
                        , style "position" "absolute"
                        , style "background" "rgba(0,0,0,0)"
                        ]
                        [ Svg.rect
                            [ SvgAttr.width (fromFloat (220 * toFloat model.enemy.life / initlife))
                            , SvgAttr.height "10"
                            , SvgAttr.x "10"
                            , SvgAttr.y "70"
                            , SvgAttr.fill "yellow"
                            ]
                            []
                        ]
                    , div
                        [ style "width" "240px"
                        , style "height" "720px"
                        , style "left" "480px"
                        , style "position" "absolute"
                        , style "color" "white"
                        , style "font-family" "Lucida Console"
                        ]
                        [ div
                            [ style "top" "50px"
                            , style "left" "10px"
                            , style "position" "absolute"
                            ]
                            [ text "BOSS" ]
                        , div
                            [ style "top" "120px"
                            , style "left" "10px"
                            , style "position" "absolute"
                            ]
                            [ text "SCORE"
                            , br [] []
                            , text (repeat (8 - (fromInt model.score |> length)) "0" ++ fromInt model.score)
                            ]
                        , div
                            [ style "top" "190px"
                            , style "left" "10px"
                            , style "position" "absolute"
                            ]
                            [ text "LIFE"
                            , br [] []
                            , text (repeat model.character.life "❤")
                            ]
                        , div
                            [ style "top" "260px"
                            , style "left" "10px"
                            , style "position" "absolute"
                            ]
                            [ text "BOMB"
                            , br [] []
                            , text (repeat model.character.bomb "✪")
                            ]
                        , div
                            [ style "top" "380px"
                            , style "left" "10px"
                            , style "position" "absolute"
                            , style "font-family" "Papyrus"
                            ]
                            [ text
                                (case level of
                                    1 ->
                                        "Parapsychologist's Mirror"

                                    2 ->
                                        "Star Sceptre"

                                    3 ->
                                        "Bloodstained Armor"

                                    _ ->
                                        "Forbbiden Zone"
                                )
                            ]
                        , div
                            [ style "top" "420px"
                            , style "left" "10px"
                            , style "position" "absolute"
                            ]
                            [ text ("LEVEL" ++ fromInt level)
                            ]
                        ]
                    , div
                        [ style "height" "100%"
                        , style "width" "100%"
                        , style "background" "rgba(0,0,0,0.5)"
                        , style "position" "absolute"
                        , style "display"
                            (case model.pause of
                                Normal ->
                                    "none"

                                _ ->
                                    "flex"
                            )
                        , style "align-items" "center"
                        , style "justify-content" "center"
                        ]
                        [ div
                            [ style "position" "absolute"
                            , style "top" "0%"
                            , style "left" "0%"
                            , style "right" "0%"
                            , style "bottom" "50%"
                            , style "display" "flex"
                            , style "align-items" "center"
                            , style "justify-content" "center"
                            , style "font-family" "Lucida Console"
                            , style "font-size" "50px"
                            , style "color" "#FFFFFF"
                            ]
                            [ text
                                (case model.pause of
                                    Pause ->
                                        "Paused"

                                    Dead _ ->
                                        "You Are Contaminated"

                                    Win _ ->
                                        "You Seal It!"

                                    Normal ->
                                        ""
                                )
                            ]
                        , button
                            [ onClick Restart
                            , style "position" "absolute"
                            , style "height" "50px"
                            , style "width" "100px"
                            , style "top" "50%"
                            , style "color" "#FCFCFC"
                            , style "background-color" "#FFA327"
                            , style "border-radius" "15px"
                            , style "border" "3px solid #EE0000"
                            , style "font-family" "Lucida Console"
                            , style "font-size" "16px"
                            ]
                            [ text "Restart" ]
                        , button
                            [ onClick Exit
                            , style "position" "absolute"
                            , style "height" "50px"
                            , style "width" "100px"
                            , style "bottom" "30%"
                            , style "color" "#FCFCFC"
                            , style "background-color" "#FFA327"
                            , style "border-radius" "15px"
                            , style "border" "3px solid #EE0000"
                            , style "font-family" "Lucida Console"
                            , style "font-size" "16px"
                            ]
                            [ text "Exit" ]
                        ]
                    ]
                ]

        Rpg ->
            div
                [ style "width" "100%"
                , style "height" "100%"
                , style "position" "absolute"
                , style "left" "0"
                , style "top" "0"
                , style "background" "black"
                ]
                [ playAudio "assets/audio/rpg.ogg"
                , div
                    [ style "width" "720px"
                    , style "height" "720px"
                    , style "position" "fixed"
                    , style "left" (String.fromFloat (Tuple.first posGame) ++ "px")
                    , style "top" (String.fromFloat (Tuple.second posGame) ++ "px")
                    ]
                    [ img
                        [ src "assets/img/background.png"
                        , alt "failed"
                        , style "position" "absolute"
                        , style "width" "100%"
                        , style "height" "100%"
                        ]
                        []
                    , div
                        [ style "width" (String.fromFloat (Tuple.first sizeGame) ++ "px")
                        , style "height" (String.fromFloat (Tuple.second sizeGame) ++ "px")
                        , style "position" "fixed"
                        ]
                        [ div
                            [ style "width" "120px"
                            , style "height" "50px"
                            , style "left" "900px"
                            , style "top" "50px"
                            , style "position" "fixed"
                            , style "color" "white"
                            , style "align-items" "center"
                            , style "font-size" "14px"
                            , style "font-family" "Lucida Console"
                            , style "color" "#FCFCFC"
                            , style "background-color" "#FFA327"
                            , style "border-radius" "8px"
                            , style "border" "1px solid #EE0000"
                            ]
                            (if List.member 1 model.levels && List.member 2 model.levels && List.member 3 model.levels then
                                [ text ("coin:  " ++ String.fromInt model.coin ++ " $")
                                , div [] []
                                , text "You success!"
                                ]

                             else
                                [ text ("coin:  " ++ String.fromInt model.coin ++ " $")
                                ]
                            )
                        , Svg.svg
                            [ SvgAttr.width "100%"
                            , SvgAttr.height "100%"
                            , style "position" "absolute"
                            ]
                            (viewPlayer model model.player :: List.map viewObject model.objects)
                        ]
                    , div
                        [ style "width" (String.fromFloat (Tuple.first sizeText) ++ "px")
                        , style "height" (String.fromFloat (Tuple.second sizeText) ++ "px")
                        , style "left" (String.fromFloat (Tuple.first topText) ++ "px")
                        , style "top" (String.fromFloat (Tuple.second topText) ++ "px")
                        , style "position" "fixed"
                        , style "color" "white"
                        ]
                        [ div
                            [ style "width" (String.fromFloat (Tuple.first sizeText) ++ "px")
                            , style "height" "20px"
                            , style "left" (String.fromFloat (Tuple.first topText) ++ "px")
                            , style "top" (String.fromFloat (Tuple.second topText) ++ "px")
                            , style "position" "fixed"
                            , style "font-size" "20px"
                            ]
                            [ case model.trigertext of
                                Object_ ->
                                    text model.text.object

                                Empty ->
                                    text ""

                                Magicfield ->
                                    viewName model "Magicfield"

                                Door1 ->
                                    viewName model "Door1"

                                Door2 ->
                                    viewName model "Door2"

                                Door3 ->
                                    viewName model "Door3"

                                Table ->
                                    viewName model "Table"

                                Painting ->
                                    viewName model "Painting"

                                President ->
                                    viewName model "President"

                                Merchant ->
                                    viewName model "Merchant"

                                Shop ->
                                    text model.text.object

                                Buy ->
                                    text " "
                            ]
                        , div
                            [ style "width" (String.fromFloat (Tuple.first sizeText - 150) ++ "px")
                            , style "height" (String.fromFloat (Tuple.second sizeText - 20) ++ "px")
                            , style "left" (String.fromFloat (Tuple.first topText) ++ "px")
                            , style "top" (String.fromFloat (Tuple.second topText + 30) ++ "px")
                            , style "position" "fixed"
                            , style "font-size" "15px"
                            ]
                            [ case model.trigertext of
                                Magicfield ->
                                    viewConversation model.count model.text.magicfield

                                Door1 ->
                                    viewConversation model.count model.text.door1

                                Door2 ->
                                    viewConversation model.count model.text.door2

                                Door3 ->
                                    viewConversation model.count model.text.door3

                                Table ->
                                    viewConversation model.count model.text.table

                                Painting ->
                                    viewConversation model.count model.text.painting

                                President ->
                                    viewConversation model.count model.text.president

                                Merchant ->
                                    viewConversation model.count model.text.merchant

                                Shop ->
                                    text "Press \"B\" to enter shop directly!"

                                Empty ->
                                    viewConversation model.count model.text.empty

                                _ ->
                                    text ""
                            ]
                        , div
                            [ style "width" "150px"
                            , style "height" "160px"
                            , style "left" "300px"
                            , style "top" (String.fromFloat (Tuple.second topText) ++ "px")
                            , style "position" "fixed"
                            ]
                            [ div
                                [ style "width" "130px"
                                , style "height" "130px"
                                , style "left" "310px"
                                , style "top" (String.fromFloat (Tuple.second topText + 10) ++ "px")
                                , style "position" "fixed"
                                ]
                                (if model.count > 0 then
                                    case model.trigertext of
                                        President ->
                                            if modBy 2 model.count == 0 then
                                                [ img
                                                    [ src "assets/img/presidentHEAD.png"
                                                    , style "position" "absolute"
                                                    ]
                                                    []
                                                ]

                                            else
                                                [ img
                                                    [ src "assets/img/selfHead.png"
                                                    , style "position" "absolute"
                                                    ]
                                                    []
                                                ]

                                        Merchant ->
                                            if modBy 2 model.count == 0 then
                                                [ img
                                                    [ src "assets/img/merchantHEAD.PNG"
                                                    , style "position" "absolute"
                                                    ]
                                                    []
                                                ]

                                            else
                                                [ img
                                                    [ src "assets/img/selfHead.png"
                                                    , style "position" "absolute"
                                                    ]
                                                    []
                                                ]

                                        _ ->
                                            [ img
                                                [ src "assets/img/selfHead.png"
                                                , style "position" "absolute"
                                                ]
                                                []
                                            ]

                                 else
                                    [ img
                                        [ src "assets/img/selfHead.png"
                                        , style "position" "absolute"
                                        ]
                                        []
                                    ]
                                )
                            ]
                        ]
                    , div
                        [ style "left" "430px"
                        , style "top" "180px"
                        , style "width" "460px"
                        , style "height" "340px"
                        , style "position" "fixed"
                        ]
                        (if model.trigertext == Buy then
                            [ img
                                [ src "assets/img/shoppage.png" ]
                                []
                            , div
                                [ style "left" "470px"
                                , style "top" "210px"
                                , style "width" "100px"
                                , style "height" "150px"
                                , style "position" "fixed"
                                , style "border-style" "solid"
                                , style "border-width" "2px"
                                , style "border-color" (judgeColors model A)
                                ]
                                []
                            , div
                                [ style "left" "610px"
                                , style "top" "210px"
                                , style "width" "100px"
                                , style "height" "150px"
                                , style "position" "fixed"
                                , style "border-style" "solid"
                                , style "border-width" "2px"
                                , style "border-color" (judgeColors model B)
                                ]
                                []
                            , div
                                [ style "left" "745px"
                                , style "top" "210px"
                                , style "width" "100px"
                                , style "height" "150px"
                                , style "position" "fixed"
                                , style "border-style" "solid"
                                , style "border-width" "2px"
                                , style "border-color" (judgeColors model C)
                                ]
                                []
                            , viewPurchaseButtons model A
                            , viewPurchaseButtons model B
                            , viewPurchaseButtons model C
                            ]

                         else
                            []
                        )
                    ]
                ]



--STG


viewEnemy : Int -> Enemy -> Html Msg
viewEnemy level enemy =
    Svg.image
        [ SvgAttr.xlinkHref ("assets/img/boss" ++ fromInt level ++ ".png")
        , enemy.pos
            |> Tuple.first
            |> (+) (enemy.r * -1)
            |> String.fromFloat
            |> SvgAttr.x
        , enemy.pos
            |> Tuple.second
            |> (+) (enemy.r * -1)
            |> String.fromFloat
            |> SvgAttr.y
        , enemy.r
            |> (*) 2
            |> String.fromFloat
            |> SvgAttr.height
        , enemy.r
            |> (*) 2
            |> String.fromFloat
            |> SvgAttr.width
        ]
        []


viewBullet : Bullet -> Html Msg
viewBullet bullet =
    case bullet.shape of
        Circle r ->
            Svg.circle
                [ bullet.pos
                    |> Tuple.first
                    |> String.fromFloat
                    |> SvgAttr.cx
                , bullet.pos
                    |> Tuple.second
                    |> String.fromFloat
                    |> SvgAttr.cy
                , SvgAttr.r (String.fromFloat r)
                , SvgAttr.fill bullet.color
                ]
                []

        Rect ( xx, yy ) ->
            let
                ( x, y ) =
                    bullet.pos

                ( vx, vy ) =
                    bullet.velocity

                alpha =
                    atan2 vy vx * 180 / pi

                a =
                    String.fromFloat x

                b =
                    String.fromFloat y

                c =
                    String.fromFloat alpha
            in
            Svg.rect
                [ SvgAttr.height (String.fromFloat xx)
                , SvgAttr.width (String.fromFloat yy)
                , x
                    |> String.fromFloat
                    |> SvgAttr.x
                , y
                    |> String.fromFloat
                    |> SvgAttr.y
                , SvgAttr.fill bullet.color
                , SvgAttr.transform ("rotate(" ++ c ++ "," ++ a ++ " " ++ b ++ ")")
                ]
                []

        Ellipse ( ry, rx ) ->
            let
                ( x, y ) =
                    bullet.pos

                ( vx, vy ) =
                    bullet.velocity

                alpha =
                    atan2 vy vx * 180 / pi

                a =
                    String.fromFloat x

                b =
                    String.fromFloat y

                c =
                    String.fromFloat alpha
            in
            Svg.ellipse
                [ x
                    |> String.fromFloat
                    |> SvgAttr.cx
                , y
                    |> String.fromFloat
                    |> SvgAttr.cy
                , SvgAttr.rx (String.fromFloat rx)
                , SvgAttr.ry (String.fromFloat ry)
                , SvgAttr.fill bullet.color
                , SvgAttr.transform ("rotate(" ++ c ++ "," ++ a ++ " " ++ b ++ ")")
                ]
                []


viewCharacter : Character -> List (Html Msg)
viewCharacter character =
    [ Svg.image
        [ SvgAttr.xlinkHref
            (case character.charactertype of
                B ->
                    "assets/img/selfsmall2.png"

                C ->
                    "assets/img/selfsmall3.png"

                _ ->
                    "assets/img/selfsmall.png"
            )
        , character.pos
            |> Tuple.first
            |> (+) -19
            |> String.fromFloat
            |> SvgAttr.x
        , character.pos
            |> Tuple.second
            |> (+) -25
            |> String.fromFloat
            |> SvgAttr.y
        ]
        []
    ]



--RPG


viewPlayer : Model -> Player -> Html Msg
viewPlayer model player =
    let
        r =
            10

        ( x, y ) =
            player.pos

        left =
            player.dir.left

        right =
            player.dir.right

        up =
            player.dir.up

        down =
            player.dir.down

        head =
            player.dir.head

        time =
            round model.time
    in
    if left == right && up == down then
        stillPicture ( x, y ) r head

    else
        movePicture ( x, y ) r head time


movePicture : ( Float, Float ) -> Float -> Head -> Int -> Html Msg
movePicture ( x, y ) r head time =
    Svg.image
        ([ SvgAttr.cx (String.fromFloat x ++ "px")
         , SvgAttr.cy (String.fromFloat y ++ "px")
         , SvgAttr.r (String.fromFloat r)
         , SvgAttr.x (String.fromFloat (x - 2.5 * r) ++ "px")
         , SvgAttr.y (String.fromFloat (y - 11 * r) ++ "px")
         , SvgAttr.width (String.fromFloat (5 * r) ++ "px")
         , SvgAttr.height (String.fromFloat (11 * r) ++ "px")
         ]
            ++ (if head == Left then
                    if modBy 220 time >= 0 && modBy 220 time <= 110 then
                        [ SvgAttr.xlinkHref "assets/img/selfmove1.png"
                        , SvgAttr.transform <| "scale(-1, 1) translate(-" ++ String.fromFloat (2 * x) ++ " 0)"
                        ]

                    else
                        [ SvgAttr.xlinkHref "assets/img/selfmove2.png"
                        , SvgAttr.transform <| "scale(-1, 1) translate(-" ++ String.fromFloat (2 * x) ++ " 0)"
                        ]

                else if modBy 220 time >= 0 && modBy 220 time <= 100 then
                    [ SvgAttr.xlinkHref "assets/img/selfmove1.png" ]

                else
                    [ SvgAttr.xlinkHref "assets/img/selfmove2.png" ]
               )
        )
        []


stillPicture : ( Float, Float ) -> Float -> Head -> Html Msg
stillPicture ( x, y ) r head =
    Svg.image
        ([ SvgAttr.cx (String.fromFloat x ++ "px")
         , SvgAttr.cy (String.fromFloat y ++ "px")
         , SvgAttr.r (String.fromFloat r)
         , SvgAttr.x (String.fromFloat (x - 2.5 * r) ++ "px")
         , SvgAttr.y (String.fromFloat (y - 11 * r) ++ "px")
         , SvgAttr.width (String.fromFloat (5 * r) ++ "px")
         , SvgAttr.height (String.fromFloat (11 * r) ++ "px")
         ]
            ++ (if head == Left then
                    [ SvgAttr.xlinkHref "assets/img/self.png"
                    , SvgAttr.transform <| "scale(-1, 1) translate(-" ++ String.fromFloat (2 * x) ++ " 0)"
                    ]

                else
                    [ SvgAttr.xlinkHref "assets/img/self.png" ]
               )
        )
        []


viewObject : Object -> Svg Msg
viewObject object =
    case object.shape of
        Rect ( width, height ) ->
            let
                ( x, y ) =
                    object.pos
            in
            -- Svg.rect
            div
                [ SvgAttr.x (String.fromFloat x ++ "px")
                , SvgAttr.y (String.fromFloat y ++ "px")
                , SvgAttr.width (String.fromFloat width ++ "px")
                , SvgAttr.height (String.fromFloat height ++ "px")
                ]
                []

        Circle r ->
            let
                ( x, y ) =
                    object.pos
            in
            div
                [ SvgAttr.cx (String.fromFloat x ++ "px")
                , SvgAttr.cy (String.fromFloat y ++ "px")
                , SvgAttr.x (String.fromFloat (x - r) ++ "px")
                , SvgAttr.y (String.fromFloat (y - r) ++ "px")
                , SvgAttr.r (String.fromFloat r)
                ]
                []

        _ ->
            div [] []


viewConversation : Int -> List String -> Html Msg
viewConversation count l =
    let
        conversation =
            withDefault " " (List.head (List.drop (count - 1) l))

        -- length = List.length
    in
    text conversation


viewName : Model -> String -> Html Msg
viewName model name =
    case modBy 2 model.count of
        1 ->
            div
                [ style "color" "red"
                , style "font-size" "20px"
                , style "align" "left"
                ]
                [ text "I:" ]

        0 ->
            div
                [ style "color" "red"
                , style "font-size" "20px"
                , style "align" "left"
                ]
                [ text (name ++ ":") ]

        _ ->
            text ""


judgeColors : Model -> CharacterType -> String
judgeColors model character =
    if model.character.charactertype == character then
        "yellow"

    else if List.member character model.own then
        "black"

    else
        "grey"


viewPurchaseButtons : Model -> CharacterType -> Html Msg
viewPurchaseButtons model character =
    if List.member character model.own then
        if model.character.charactertype /= character then
            button
                [ onClick (Choose character)
                , style "height" "35px"
                , style "width" "60px"
                , style "position" "absolute"
                , style "left" (String.fromInt (decidePosition character) ++ "%")
                , style "bottom" "30%"
                , style "color" "black"
                , style "border-radius" "15px"
                , style "background-color" "yellow"
                ]
                [ text "Choose" ]

        else
            button
                [ style "height" "35px"
                , style "width" "60px"
                , style "position" "absolute"
                , style "left" (String.fromInt (decidePosition character) ++ "%")
                , style "bottom" "30%"
                , style "color" "black"
                , style "border-radius" "15px"
                , style "background-color" "yellow"

                -- , style "text-align" "center"
                ]
                [ text "In Use" ]

    else if character == B then
        button
            [ onClick (Purchase B)
            , style "height" "35px"
            , style "width" "50px"
            , style "position" "absolute"
            , style "left" "45%"
            , style "bottom" "30%"
            , style "color" "black"
            , style "border-radius" "15px"
            , style "background-color" "yellow"
            ]
            [ text "999$" ]

    else if character == C then
        button
            [ onClick (Purchase C)
            , style "height" "35px"
            , style "width" "50px"
            , style "position" "absolute"
            , style "left" "75%"
            , style "bottom" "30%"
            , style "color" "black"
            , style "border-radius" "15px"
            , style "background-color" "yellow"
            ]
            [ text "9999$" ]

    else if character == A then
        button
            [ onClick (Purchase A)
            , style "height" "35px"
            , style "width" "50px"
            , style "position" "absolute"
            , style "left" "15%"
            , style "bottom" "30%"
            , style "color" "black"
            , style "border-radius" "15px"
            , style "background-color" "yellow"
            ]
            [ text "99$" ]

    else
        button [] []


decidePosition : CharacterType -> Int
decidePosition character =
    case character of
        A ->
            15

        B ->
            45

        C ->
            75

        _ ->
            0


playAudio : String -> Html msg
playAudio file =
    audio
        [ id "audio_player"
        , src file
        , autoplay True
        , loop True
        , style "display" "none"
        ]
        []
