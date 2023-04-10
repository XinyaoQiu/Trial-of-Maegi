port module Update exposing (update)

{-| This module implement the `update` function for the game.


# Interface

@docs update

-}

import BulletGen exposing (..)
import Maybe exposing (..)
import Messages exposing (..)
import Model exposing (..)
import UpdateRPG exposing (updateRPG)
import UpdateSTG exposing (updateSTG)
import Vector exposing (..)


port volumeUp : () -> Cmd msg


port volumeDown : () -> Cmd msg


{-| Update the model and yield commands to the elm frontend.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        cmd =
            case msg of
                KeyDown 187 ->
                    volumeUp ()

                KeyDown 189 ->
                    volumeDown ()

                _ ->
                    Cmd.none
    in
    case model.state of
        Stg level ->
            ( updateSTG level msg model, cmd )

        Rpg ->
            ( updateRPG msg model, cmd )
