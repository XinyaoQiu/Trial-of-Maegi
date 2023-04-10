module Messages exposing (CharacterType(..), Msg(..))

{-| This module defines the `Msg` type and its components.


# Definition

@docs CharacterType, Msg

-}


{-| A `CharacterType` describes the character used in STG part, or is `None` to stop player from entering the game.
-}
type CharacterType
    = A
    | B
    | C
    | None


{-| The `Msg` type illustrates the communication between the backend and the frontend.
-}
type Msg
    = Tick Float
    | KeyUp Int
    | KeyDown Int
    | Restart
    | Exit
    | Purchase CharacterType
    | Choose CharacterType
