module Main exposing (main, subscriptions)

{-| This module is the main module for the game.


# Interface

@docs main, subscriptions

-}

import Browser
import Browser.Events exposing (onAnimationFrameDelta, onKeyDown, onKeyUp)
import Html exposing (..)
import Html.Events exposing (keyCode)
import Json.Decode as Decode
import Messages exposing (..)
import Model exposing (..)
import Update exposing (..)
import View exposing (..)


{-| -}
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


{-| -}
subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ onAnimationFrameDelta Tick
        , onKeyUp (Decode.map KeyUp keyCode)
        , onKeyDown (Decode.map KeyDown keyCode)
        ]
