module Model exposing
    ( ShipType(..), Shape(..), Bullet, Enemy, Character, State(..), PauseState(..), Model, Player, Dir, Head(..), TrigerText(..), Text, Object
    , seed0, moveDistance, posGame, sizeGame, topText, sizeText, objectEmpty, canvasWidth, canvasHeight
    , initPlayer, initDir, initText, initObjects, initEnemy, initCharacter1, initCharacter2, initCharacter3, initLevel, init
    , toIdentity
    )

{-| This module defines the `Model` type and its components for the game,
and defines some related constants and initialization functions.


# Definition

@docs ShipType, Shape, Bullet, Enemy, Character, State, PauseState, Model, Player, Dir, Head, TrigerText, Text, Object


# Constants

@docs seed0, moveDistance, posGame, sizeGame, topText, sizeText, objectEmpty, canvasWidth, canvasHeight


# Initializations

@docs initPlayer, initDir, initText, initObjects, initEnemy, initCharacter1, initCharacter2, initCharacter3, initLevel, init


# Helper

@docs toIdentity

-}

import Messages exposing (..)
import Random


{-| -}
type ShipType
    = Self
    | Boss


{-| -}
type Shape
    = Rect ( Float, Float )
    | Circle Float
    | Ellipse ( Float, Float )


{-| -}
type alias Bullet =
    { pos : ( Float, Float )
    , velocity : ( Float, Float )
    , shiptype : ShipType
    , shape : Shape
    , color : String

    -- , stroke : String
    -- , opacity : Float
    }


{-| -}
type alias Enemy =
    { pos : ( Float, Float )
    , r : Float
    , velocity : ( Float, Float )
    , life : Int
    }


{-| -}
type alias Character =
    { pos : ( Float, Float )
    , slow : Bool
    , moveU : Bool
    , moveD : Bool
    , moveL : Bool
    , moveR : Bool
    , shoot : Bool
    , shootTime : Int
    , life : Int
    , bomb : Int
    , charactertype : CharacterType
    }


{-| -}
type State
    = Rpg
    | Stg Int


{-| -}
type PauseState
    = Pause
    | Dead Int
    | Win Int
    | Normal


{-| -}
type alias Model =
    { bullets : List Bullet
    , time : Float
    , bulletTime : Int
    , round : Int
    , enemy : Enemy
    , character : Character
    , player : Player
    , text : Text
    , trigertext : TrigerText
    , objects : List Object
    , count : Int
    , coin : Int
    , state : State
    , pause : PauseState
    , seed : Random.Seed
    , score : Int
    , own : List CharacterType
    , levels : List Int
    }


{-| -}
seed0 : Random.Seed
seed0 =
    Random.initialSeed 42



--RPG


{-| -}
moveDistance : Float
moveDistance =
    3


{-| -}
posGame : ( Float, Float )
posGame =
    ( 300, 30 )


{-| -}
sizeGame : ( Float, Float )
sizeGame =
    ( 720, 560 )


{-| -}
topText : ( Float, Float )
topText =
    ( 450, 590 )


{-| -}
sizeText : ( Float, Float )
sizeText =
    ( 720, 160 )


{-| -}
type alias Player =
    { dir : Dir
    , pos : ( Float, Float )
    , v : ( Float, Float )
    }


{-| -}
initPlayer : Player
initPlayer =
    { dir = initDir, pos = ( 690, 550 ), v = ( 0, 0 ) }


{-| -}
type alias Dir =
    { up : Bool
    , down : Bool
    , left : Bool
    , right : Bool
    , head : Head
    }


{-| -}
type Head
    = Left
    | Right


{-| -}
initDir : Dir
initDir =
    Dir False False False False Left


{-| -}
type TrigerText
    = Object_
    | Empty
    | Magicfield
    | Door1
    | Door2
    | Door3
    | Table
    | Painting
    | President
    | Merchant
    | Shop
    | Buy


{-| -}
type alias Text =
    { object : String
    , magicfield : List String
    , door1 : List String
    , door2 : List String
    , door3 : List String
    , table : List String
    , painting : List String
    , president : List String
    , merchant : List String
    , empty : List String
    }


{-| -}
initText : Text
initText =
    Text
        "Press \"C\" to start conversation"
        [ "(Looking carefully at the magic field.)"
        , "You can pay some coins to practice your shooting skill here. Press \"1\" to pay 100 dollors and pratcise level 1. Press \"2\" to pay 200 dollors and pratcise level 2. Press \"3\" to pay 300 dollors and pratcise level 3. "
        ]
        [ "(Looking carefully at the door.)", "Inside sealed The Parapsychologist's Mirror. Capability: Shoot a lot of magical bullets. Create mirrors to reflect on all bullets. Press 's' to get in!" ]
        [ "(Looking carefully at the door.)"
        , "Inside sealed The Bloodstained Armor. Capability: Immune to any bullets for a period. Press 's' to get in! It's more dangerous and you'd better complete other two trials before entering this one."
        ]
        [ "(Looking carefully at the door.)"
        , "Inside sealed The Star Sceptre. Capability: Larger and faster bullets. Press 's' to get in!"
        ]
        [ "(Looking carefully at the table)"
        , "Documents about the sealed objects are on the table. The level of them are Dangerous."
        ]
        [ "(Looking carefully at the painting)"
        , "Depiction of several people under the starry sky. In the middle is the President."
        , "(Searching for the instructions.)"
        , "Instructions for STG: Press 'z' to shoot bullets. Press 'Shift' to slow down self's speed. Press 'x' to use bombs to clear boss's bullets."
        ]
        [ "Dear President, I'm Maegi. An undergraduate from Magic University."
        , "Welcome Maegi. I'm the president of Night, the most famous magician association in the world."
        , "I'm eager to become a member of Night. What should I do?"
        , "Three trials for you, dear Maegi. Retrieve three magical objects that are out of control in the dungeon, and then become a member of Night! Instructions are shown in the painting on the right side of this room. But first use 99 dollors to buy your first character! If you pass through the three levels, you will be submitted."
        ]
        [ "Dear Merchant, I'm Maegi. What can I get from you?"
        , "Welcome Maegi. I provide some beautiful skins with different capabilities that helps your battle with magical objects."
        , "Sounds great! How can I exchange them?"
        , "Prepare enough coins(winning awards you coins). And press 'b' to open the shop page. Press 'Esc' to close it."
        ]
        [ "Maegi, please get close to the red-hair woman and chat with her. (A sound in your head)." ]


{-| -}
type alias Object =
    { pos : ( Float, Float )

    -- , size : ( Float, Float )
    , shape : Shape

    -- , radius : Float
    , name : String
    }


{-| -}
objectEmpty : Object
objectEmpty =
    Object posGame (Rect sizeGame) ""


{-| -}
initObjects : List Object
initObjects =
    [ Object ( 330, 350 ) (Circle 130) "magic field"
    , Object ( 90, 30 ) (Rect ( 90, 140 )) "door1"
    , Object ( 260, 20 ) (Rect ( 130, 150 )) "door2"
    , Object ( 460, 30 ) (Rect ( 90, 140 )) "door3"
    , Object ( 49, 205 ) (Rect ( 100, 290 )) "table"
    , Object ( 591, 149 ) (Rect ( 130, 130 )) "painting"
    , Object ( -1, 290 ) (Rect ( 151, 150 )) "president"
    , Object ( 475, 410 ) (Rect ( 85, 145 )) "merchant"
    ]



--STG


{-| -}
canvasWidth : number
canvasWidth =
    480


{-| -}
canvasHeight : number
canvasHeight =
    720


{-| -}
initEnemy : Enemy
initEnemy =
    Enemy ( 400, 200 ) 60 ( 0, 0 ) 500


{-| -}
initCharacter1 : Character
initCharacter1 =
    Character ( canvasWidth / 2, canvasHeight ) False False False False False False 0 5 5 A


{-| -}
initCharacter2 : Character
initCharacter2 =
    Character ( canvasWidth / 2, canvasHeight ) False False False False False False 0 10 5 B


{-| -}
initCharacter3 : Character
initCharacter3 =
    Character ( canvasWidth / 2, canvasHeight ) False False False False False False 0 10 8 C


{-| -}
initLevel : Int -> Model -> Model
initLevel level model =
    let
        character =
            case model.character.charactertype of
                A ->
                    initCharacter1

                B ->
                    initCharacter2

                C ->
                    initCharacter3

                None ->
                    { initCharacter1 | charactertype = None }

        enemy =
            case level of
                1 ->
                    { initEnemy | life = 1000 }

                2 ->
                    { initEnemy | life = 800 }

                3 ->
                    { initEnemy | life = 1500 }

                _ ->
                    initEnemy
    in
    Model [] 0 0 0 enemy character model.player model.text model.trigertext model.objects model.count model.coin (Stg level) Normal model.seed 0 model.own model.levels


{-| -}
init : () -> ( Model, Cmd Msg )
init _ =
    ( Model [] 0 0 0 initEnemy { initCharacter1 | charactertype = None } initPlayer initText Empty initObjects 0 0 Rpg Normal seed0 0 [] [], Cmd.none )


{-| -}
toIdentity : Bool -> number
toIdentity flag =
    if flag then
        1

    else
        0
