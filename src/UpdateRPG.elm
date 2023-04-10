module UpdateRPG exposing (updateRPG, updatePlayer, judge_if_move, update_player_dir, update_player_pos, normal_move, boundry_limit, update_player_v, judge_inside, trigerText, conversation, changeToSTG, purchaseCharacter, beSubmitted)

{-| This module is a submodule for [`Update.update`](Update#update), updating the RPG part.


# Interface

@docs updateRPG, updatePlayer, judge_if_move, update_player_dir, update_player_pos, normal_move, boundry_limit, update_player_v, judge_inside, trigerText, conversation, changeToSTG, purchaseCharacter, beSubmitted

-}

import Maybe exposing (..)
import Messages exposing (..)
import Model exposing (..)
import Vector exposing (..)


{-| -}
updateRPG : Msg -> Model -> Model
updateRPG msg =
    updatePlayer msg
        >> changeText
        >> trigerText
        >> trigerConversation msg
        >> conversation msg
        >> changeToSTG msg
        >> changeTime msg
        >> trigerShop
        >> enterShop msg
        >> purchaseCharacter msg
        >> backToMerchant msg
        >> exitShop msg
        >> forceBuyCharacter
        >> beSubmitted

{-| Update the player according the msg. The player will get new direction, position and velocity after this function.
-}
updatePlayer : Msg -> Model -> Model
updatePlayer msg model =
    let
        player =
            model.player

        ( x, y ) =
            player.pos

        ( vx, vy ) =
            player.v

        dir =
            player.dir

        new_dir_dir =
            update_player_dir msg dir

        new_dir_head =
            if new_dir_dir.right && not new_dir_dir.left then
                Right

            else if not new_dir_dir.right && new_dir_dir.left then
                Left

            else
                model.player.dir.head

        new_dir =
            { new_dir_dir | head = new_dir_head }

        new_v =
            update_player_v ( vx, vy ) new_dir

        new_pos =
            judge_if_move msg model ( x, y ) new_v

        new_player =
            { player | dir = new_dir, v = ( 0, 0 ), pos = new_pos }
    in
    { model | player = new_player }





{-| Judge whether the player can move. If the player is in the conversation, it can not move away. If trigertext is not Empty,
Shop and Object_, which means the player is in the conversation, it can not move.
-}
judge_if_move : Msg -> Model -> ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
judge_if_move msg model ( x, y ) ( vx, vy ) =
    case msg of
        Tick elapsed ->
            if model.trigertext == Empty || model.trigertext == Object_ then
                update_player_pos model ( x, y ) ( vx * elapsed / 18, vy * elapsed / 18 )

            else if model.trigertext == Shop then
                update_player_pos model ( x, y ) ( vx * elapsed / 18, vy * elapsed / 18 )

            else
                model.player.pos

        _ ->
            model.player.pos

{-| Update the direction of the character according to the keycode. If keydown `up`, then the diection will be Up. If keyup 
`up`, then the Up direction will be false and then the player will not move upward.-}
update_player_dir : Msg -> Dir -> Dir
update_player_dir msg dir =
    case msg of
        KeyDown n ->
            dir_change_keydown n dir

        KeyUp n ->
            dir_change_keyup n dir

        _ ->
            dir


dir_change_keydown : Int -> Dir -> Dir
dir_change_keydown n dir =
    if n == 38 then
        { dir | up = True }

    else if n == 40 then
        { dir | down = True }

    else if n == 37 then
        { dir | left = True }

    else if n == 39 then
        { dir | right = True }

    else
        dir


dir_change_keyup : Int -> Dir -> Dir
dir_change_keyup n dir =
    if n == 38 then
        { dir | up = False }

    else if n == 40 then
        { dir | down = False }

    else if n == 37 then
        { dir | left = False }

    else if n == 39 then
        { dir | right = False }

    else
        dir

{-| Update the position of the player. If there is no walls or objects in its way, she will move at her pace. Otherwise, she will
stop.
-}
update_player_pos : Model -> ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
update_player_pos model ( x, y ) ( vx, vy ) =
    ( x, y )
        |> normal_move ( vx, vy )
        |> boundry_limit
        |> judge_inside model ( vx, vy )



-- the normal move of the character if there is no boundry and barrier
-- Input v and current position

{-| The player moves at her speed.
-}
normal_move : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
normal_move ( vx, vy ) ( x, y ) =
    ( vx + x, vy + y )



--the boundry will limit the movement
-- Input the current position

{-| The player will stop if she encounters with the wall or boundry
-}
boundry_limit : ( Float, Float ) -> ( Float, Float )
boundry_limit ( x, y ) =
    let
        ( width, height ) =
            sizeGame

        ( new_width, new_height ) =
            ( width - 23, height )

        new_x =
            if x < 23 then
                23

            else if x > new_width then
                new_width

            else
                x

        new_y =
            if y < 170 then
                170

            else if y > new_height then
                new_height

            else
                y
    in
    ( new_x, new_y )

{-| Change the velocity of the character accoring to her direction. -}
update_player_v : ( Float, Float ) -> Dir -> ( Float, Float )
update_player_v ( vx, vy ) dir =
    ( vx, vy )
        |> update_player_v_down dir.down
        |> update_player_v_left dir.left
        |> update_player_v_right dir.right
        |> update_player_v_up dir.up
        |> lower_v


update_player_v_left : Bool -> ( Float, Float ) -> ( Float, Float )
update_player_v_left bool ( vx, vy ) =
    if bool then
        ( vx - moveDistance, vy )

    else
        ( vx, vy )


update_player_v_right : Bool -> ( Float, Float ) -> ( Float, Float )
update_player_v_right bool ( vx, vy ) =
    if bool then
        ( vx + moveDistance, vy )

    else
        ( vx, vy )


update_player_v_up : Bool -> ( Float, Float ) -> ( Float, Float )
update_player_v_up bool ( vx, vy ) =
    if bool then
        ( vx, vy - moveDistance )

    else
        ( vx, vy )


update_player_v_down : Bool -> ( Float, Float ) -> ( Float, Float )
update_player_v_down bool ( vx, vy ) =
    if bool then
        ( vx, vy + moveDistance )

    else
        ( vx, vy )



-- if the player control the character to move in both direction, we should reduce the speed


lower_v : ( Float, Float ) -> ( Float, Float )
lower_v ( vx, vy ) =
    let
        speed =
            sqrt (vx * vx + vy * vy)
    in
    if speed > moveDistance then
        ( vx / sqrt 2, vy / sqrt 2 )

    else
        ( vx, vy )



--Judge whether the player is inside the objects


judge_inside_help_1 : ( Float, Float ) -> ( Float, Float ) -> Object -> ( Float, Float )
judge_inside_help_1 ( vx, vy ) ( x, y ) object =
    let
        ( pos_x, pos_y ) =
            object.pos
    in
    case object.shape of
        Rect ( width, height ) ->
            let
                ( left, right ) =
                    ( pos_x, pos_x + width )

                ( up, down ) =
                    ( pos_y, pos_y + height )
            in
            if x > left && x < right then
                if y > up && y < down then
                    find_edge ( pos_x, pos_y ) ( width, height ) ( vx, vy ) ( x, y )

                else
                    ( x, y )

            else
                ( x, y )

        Circle r ->
            let
                dx =
                    pos_x - x

                dy =
                    pos_y - y

                distance =
                    sqrt (dx * dx + dy * dy)
            in
            if distance < r then
                judge_for_circle ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

            else
                ( x, y )

        _ ->
            ( x, y )


judge_inside_help_2 : Int -> Model -> ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
judge_inside_help_2 n model ( vx, vy ) ( x, y ) =
    let
        len =
            List.length model.objects
    in
    if n <= len then
        let
            obj =
                withDefault objectEmpty (List.head (List.drop (n - 1) model.objects))

            ( new_x, new_y ) =
                judge_inside_help_1 ( vx, vy ) ( x, y ) obj
        in
        judge_inside_help_2 (n + 1) model ( vx, vy ) ( new_x, new_y )

    else
        ( x, y )

{-| If the player go into the objects, she will stop at the edge of the object. And message that the player is 
close to the object will be sent to model. Hence, player will be informed whether to start conversation.-}
judge_inside : Model -> ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
judge_inside model ( vx, vy ) ( x, y ) =
    judge_inside_help_2 1 model ( vx, vy ) ( x, y )



-- Use recursive  to find the point on the circle
-- point_on_circle: Float -> (Float,Float) -> (Float,Float) -> (Float,Float) -> (Float,Float)
-- point_on_circle r (pos_x,pos_y) (vx,vy) (x,y) =
--     let
--         dx = x - pos_x
--         dy = y - pos_y
--         distance = sqrt( dx * dx + dy * dy)
--     in
--         if abs(distance - r) < 0.1 then
--             (x,y)
--         else
--             point_on_circle r (pos_x,pos_y) (vx,vy) (x - 0.01 * vx,y - 0.01 * vy)


find_edge : ( Float, Float ) -> ( Float, Float ) -> ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
find_edge ( pos_x, pos_y ) ( width, height ) ( vx, vy ) ( x, y ) =
    if vx == 0 && vy > 0 then
        ( x, pos_y )

    else if vx == 0 && vy < 0 then
        ( x, pos_y + height )

    else if vy == 0 && vx > 0 then
        ( pos_x, y )

    else if vy == 0 && vx < 0 then
        ( pos_x + width, y )

    else if vx > 0 && vy < 0 then
        if (x + y) < pos_x + pos_y + height then
            ( pos_x, y )

        else
            ( x, pos_y + height )

    else if vx > 0 && vy > 0 then
        if (y - x) > (pos_y - pos_x) then
            ( pos_x, y )

        else
            ( x, pos_y )

    else if vx < 0 && vy < 0 then
        if (y - x) > (pos_y + height - pos_x - width) then
            ( x, pos_y + height )

        else
            ( pos_x + width, y )

    else if (x + y) > (pos_x + width + pos_y) then
        ( pos_x + width, y )

    else
        ( x, pos_y )


judge_for_circle : ( Float, Float ) -> Float -> ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
judge_for_circle ( pos_x, pos_y ) r ( vx, vy ) ( x, y ) =
    if x <= pos_x && y >= pos_y then
        if vx > 0 then
            if vy > 0 then
                -- ( pos_x - sqrt (r ^ 2 - (y - pos_y) ^ 2), y )
                circle_left ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

            else if vy == 0 then
                -- ( x, pos_y + sqrt (r ^ 2 - (x - pos_x) ^ 2) )
                circle_down ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

            else
                -- ( pos_x - sqrt (r ^ 2 - (y - pos_y) ^ 2), y )
                circle_left ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

        else if vx == 0 && vy < 0 then
            -- ( pos_x - sqrt (r ^ 2 - (y - pos_y) ^ 2), y )
            circle_left ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

        else if vx < 0 && vy < 0 then
            -- ( x, pos_y + sqrt (r ^ 2 - (x - pos_x) ^ 2) )
            circle_down ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

        else
            ( x, y )

    else if x <= pos_x && y < pos_y then
        if vx > 0 then
            if vy > 0 then
                -- ( pos_x - sqrt (r ^ 2 - (y - pos_y) ^ 2), y )
                circle_left ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

            else if vy == 0 then
                -- ( x, pos_y - sqrt (r ^ 2 - (x - pos_x) ^ 2) )
                circle_up ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

            else
                -- ( pos_x - sqrt (r ^ 2 - (y - pos_y) ^ 2), y )
                circle_left ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

        else if vx == 0 && vy > 0 then
            -- ( pos_x - sqrt (r ^ 2 - (y - pos_y) ^ 2), y )
            circle_left ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

        else if vx < 0 && vy > 0 then
            -- ( x, pos_y - sqrt (r ^ 2 - (x - pos_x) ^ 2) )
            circle_up ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

        else
            ( x, y )

    else if x >= pos_x && y <= pos_y then
        if vx < 0 then
            if vy > 0 then
                circle_up ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

            else if vy == 0 then
                circle_up ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

            else
                circle_right ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

        else if vx == 0 && vy > 0 then
            circle_right ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

        else if vx > 0 && vy > 0 then
            circle_up ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

        else
            ( x, y )

    else if vx < 0 then
        if vy > 0 then
            circle_right ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

        else if vy == 0 then
            circle_down ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

        else
            circle_right ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

    else if vx == 0 && vy < 0 then
        circle_right ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

    else if vx > 0 && vy < 0 then
        circle_down ( pos_x, pos_y ) r ( vx, vy ) ( x, y )

    else
        ( x, y )


circle_down : ( Float, Float ) -> Float -> ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
circle_down ( pos_x, pos_y ) r ( vx, vy ) ( x, y ) =
    let
        move_distance =
            sqrt (r ^ 2 - (x - pos_x) ^ 2)

        angle1 =
            acos ((x - pos_x) / sqrt ((x - pos_x) ^ 2 + (y - pos_y) ^ 2))

        angle2 =
            acos ((x - pos_x) / sqrt ((x - pos_x) ^ 2 + move_distance ^ 2))

        angle =
            (angle1 + angle2) / 2
    in
    if move_distance > 3 * moveDistance / 5 then
        ( pos_x + r * cos angle, pos_y + r * sin angle )

    else
        ( x, pos_y + move_distance )


circle_up : ( Float, Float ) -> Float -> ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
circle_up ( pos_x, pos_y ) r ( vx, vy ) ( x, y ) =
    let
        move_distance =
            sqrt (r ^ 2 - (x - pos_x) ^ 2)

        angle1 =
            acos ((x - pos_x) / sqrt ((x - pos_x) ^ 2 + (y - pos_y) ^ 2))

        angle2 =
            acos ((x - pos_x) / sqrt ((x - pos_x) ^ 2 + move_distance ^ 2))

        angle =
            (angle1 + angle2) / 2
    in
    if move_distance > 3 * moveDistance / 5 then
        ( pos_x + r * cos angle, pos_y - r * sin angle )

    else
        ( x, pos_y - move_distance )


circle_left : ( Float, Float ) -> Float -> ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
circle_left ( pos_x, pos_y ) r ( vx, vy ) ( x, y ) =
    let
        move_distance =
            sqrt (r ^ 2 - (y - pos_y) ^ 2)

        angle1 =
            acos ((x - pos_x) / sqrt ((x - pos_x) ^ 2 + (y - pos_y) ^ 2))

        angle2 =
            acos (-move_distance / sqrt (move_distance ^ 2 + (y - pos_y) ^ 2))

        angle =
            (angle1 + angle2) / 2
    in
    if move_distance > 3 * moveDistance / 5 then
        if y <= pos_y then
            ( pos_x + r * cos angle, pos_y - r * sin angle )

        else
            ( pos_x + r * cos angle, pos_y + r * sin angle )

    else
        ( pos_x - move_distance, y )


circle_right : ( Float, Float ) -> Float -> ( Float, Float ) -> ( Float, Float ) -> ( Float, Float )
circle_right ( pos_x, pos_y ) r ( vx, vy ) ( x, y ) =
    let
        move_distance =
            sqrt (r ^ 2 - (y - pos_y) ^ 2)

        angle1 =
            acos ((x - pos_x) / sqrt ((x - pos_x) ^ 2 + (y - pos_y) ^ 2))

        angle2 =
            acos (move_distance / sqrt (move_distance ^ 2 + (y - pos_y) ^ 2))

        angle =
            (angle1 + angle2) / 2
    in
    if move_distance > 3 * moveDistance / 5 then
        if y <= pos_y then
            ( pos_x + r * cos angle, pos_y - r * sin angle )

        else
            ( pos_x + r * cos angle, pos_y + r * sin angle )

    else
        ( pos_x + move_distance, y )


triger_text_helper_1 : Model -> Object -> Model
triger_text_helper_1 model object =
    let
        ( pos_x, pos_y ) =
            object.pos

        ( x, y ) =
            model.player.pos
    in
    if model.trigertext == Empty then
        case object.shape of
            Rect ( width, height ) ->
                let
                    l =
                        pos_x - 0.1

                    r =
                        pos_x + width + 0.1

                    u =
                        pos_y - 0.1

                    d =
                        pos_y + height + 0.1
                in
                if x >= l && x <= r then
                    if y >= u && y <= d then
                        { model | trigertext = Object_ }

                    else
                        model

                else
                    model

            Circle r ->
                let
                    dx =
                        pos_x - x

                    dy =
                        pos_y - y

                    distance =
                        sqrt (dx * dx + dy * dy)
                in
                if abs (distance - r) < 0.01 then
                    { model | trigertext = Object_ }

                else
                    model

            _ ->
                model

    else
        model


triger_text_helper_2 : Int -> Int -> Model -> ( Model, Int )
triger_text_helper_2 n count model =
    let
        len =
            List.length model.objects
    in
    if n <= len then
        let
            obj =
                withDefault objectEmpty (List.head (List.drop (n - 1) model.objects))

            neomodel =
                triger_text_helper_1 model obj

            m =
                if neomodel.trigertext /= Object_ then
                    n

                else
                    count
        in
        triger_text_helper_2 (n + 1) m neomodel

    else
        ( model, count + 1 )

{-| Triger text when the player is close to the object. 
-}
trigerText : Model -> ( Model, Int )
trigerText model =
    triger_text_helper_2 1 0 model


changeText : Model -> Model
changeText model =
    if model.trigertext == Object_ || model.trigertext == Shop then
        { model | trigertext = Empty, count = 0 }

    else
        model


trigerConversation : Msg -> ( Model, Int ) -> Model
trigerConversation msg ( model, n ) =
    let
        which_text =
            case n of
                1 ->
                    Magicfield

                2 ->
                    Door1

                3 ->
                    Door2

                4 ->
                    Door3

                5 ->
                    Table

                6 ->
                    Painting

                7 ->
                    President

                8 ->
                    Merchant

                _ ->
                    Empty
    in
    if model.trigertext == Object_ then
        case msg of
            KeyDown 67 ->
                { model | trigertext = which_text, count = 1 }

            _ ->
                model

    else
        model

{-| Help continue the converaation. When `enter` is pressed, the next sentence appear-}
conversation : Msg -> Model -> Model
conversation msg model =
    let
        count =
            model.count

        trigertext =
            model.trigertext

        length =
            get_length trigertext model
    in
    case msg of
        KeyDown 13 ->
            if trigertext /= Empty && trigertext /= Object_ then
                if trigertext /= Shop then
                    if count < length then
                        { model | count = count + 1 }

                    else if count == length then
                        { model | trigertext = Object_ }

                    else
                        model

                else
                    model

            else
                model

        _ ->
            model


get_length : TrigerText -> Model -> Int
get_length trigertext model =
    case trigertext of
        Magicfield ->
            List.length model.text.magicfield

        Door1 ->
            List.length model.text.door1

        Door2 ->
            List.length model.text.door2

        Door3 ->
            List.length model.text.door3

        Table ->
            List.length model.text.table

        Painting ->
            List.length model.text.painting

        President ->
            List.length model.text.president

        Merchant ->
            List.length model.text.merchant

        _ ->
            0

{-| Change the game to the stg part. -}
changeToSTG : Msg -> Model -> Model
changeToSTG msg model =
    if model.character.charactertype /= None then
        case model.trigertext of
            Door1 ->
                if model.count == get_length Door1 model then
                    case msg of
                        KeyDown 83 ->
                            initLevel 1 model

                        _ ->
                            model

                else
                    model

            Door3 ->
                if model.count == get_length Door2 model then
                    case msg of
                        KeyDown 83 ->
                            initLevel 2 model

                        _ ->
                            model

                else
                    model

            Door2 ->
                if model.count == get_length Door3 model then
                    case msg of
                        KeyDown 83 ->
                            initLevel 3 model

                        _ ->
                            model

                else
                    model

            Magicfield ->
                if model.count == get_length Magicfield model then
                    case msg of
                        KeyDown 49 ->
                            if model.coin >= 100 then
                                let
                                    new_model =
                                        initLevel 1 model
                                in
                                { new_model | coin = model.coin - 100 }

                            else
                                model

                        KeyDown 50 ->
                            if model.coin >= 200 then
                                let
                                    new_model =
                                        initLevel 2 model
                                in
                                { new_model | coin = model.coin - 200 }

                            else
                                model

                        KeyDown 51 ->
                            if model.coin >= 300 then
                                let
                                    new_model =
                                        initLevel 3 model
                                in
                                { new_model | coin = model.coin - 300 }

                            else
                                model

                        _ ->
                            model

                else
                    model

            _ ->
                model

    else
        model


changeTime : Msg -> Model -> Model
changeTime msg model =
    case msg of
        Tick elaped ->
            { model | time = model.time + elaped }

        _ ->
            model



-- this function is used to help the character enter shop


enterShop : Msg -> Model -> Model
enterShop msg model =
    if model.trigertext == Merchant then
        case msg of
            KeyDown 66 ->
                if model.count == get_length Merchant model then
                    { model | trigertext = Buy }

                else
                    model

            _ ->
                model

    else if model.trigertext == Shop then
        case msg of
            KeyDown 66 ->
                { model | trigertext = Buy }

            _ ->
                model

    else
        model



-- this function is used to triger text "Press "b" to enter the shop". And "shop" state can further enter "Buy" state.


trigerShop : Model -> Model
trigerShop model =
    let
        merchant =
            Object ( 475, 410 ) (Rect ( 85, 145 )) "merchant"

        ( pos_x, pos_y ) =
            merchant.pos

        width =
            85

        height =
            145

        ( x, y ) =
            model.player.pos

        l =
            pos_x - 0.1

        r =
            pos_x + width + 0.1

        u =
            pos_y - 0.1

        d =
            pos_y + height + 0.1
    in
    if model.trigertext /= Buy && model.trigertext /= Merchant then
        if x >= l && x <= r then
            if y >= u && y <= d then
                { model | trigertext = Shop }

            else
                model

        else
            model

    else
        model



-- if the character start the conversation, then the trigertext should be changed to Merchant


backToMerchant : Msg -> Model -> Model
backToMerchant msg model =
    if model.trigertext == Shop || model.trigertext == Object_ then
        case msg of
            KeyDown 67 ->
                { model | trigertext = Merchant, count = 1 }

            _ ->
                model

    else
        model


exitShop : Msg -> Model -> Model
exitShop msg model =
    if model.trigertext == Buy then
        case msg of
            KeyDown 27 ->
                { model | trigertext = Object_ }

            _ ->
                model

    else
        model

{-| Buy the character and deduct the dollars -}
purchaseCharacter : Msg -> Model -> Model
purchaseCharacter msg model =
    if model.trigertext == Buy then
        case msg of
            Choose character ->
                let
                    old_character =
                        model.character

                    new_character =
                        { old_character | charactertype = character }
                in
                { model | character = new_character }

            Purchase character ->
                if character == B then
                    if model.coin >= 999 then
                        let
                            new_own =
                                B :: model.own

                            new_coin =
                                model.coin - 999
                        in
                        { model | own = new_own, coin = new_coin }

                    else
                        model

                else if character == C then
                    if model.coin >= 9999 then
                        let
                            new_own =
                                C :: model.own

                            new_coin =
                                model.coin - 9999
                        in
                        { model | own = new_own, coin = new_coin }

                    else
                        model

                else if character == A then
                    if model.coin >= 99 then
                        let
                            new_own =
                                A :: model.own

                            new_coin =
                                model.coin - 99
                        in
                        { model | own = new_own, coin = new_coin }

                    else
                        model

                else
                    model

            _ ->
                model

    else
        model


forceBuyCharacter : Model -> Model
forceBuyCharacter model =
    if model.text.empty /= [ "" ] then
        if model.trigertext == President then
            let
                text =
                    model.text

                new_text =
                    { text | empty = [ "please go close to the man and buy a character from him and then choose it" ] }
            in
            { model | text = new_text, coin = 99 }

        else if model.trigertext == Merchant || model.trigertext == Shop then
            if model.text.empty == [ "please go close to the man and buy a character from him and then choose it" ] then
                if model.character.charactertype /= None then
                    let
                        text =
                            model.text

                        new_text =
                            { text | empty = [ "" ] }
                    in
                    { model | text = new_text }

                else
                    model

            else
                model

        else
            model

    else
        model


{-| Change the text of the president if the player pass three levels-}
beSubmitted : Model -> Model
beSubmitted model =
    if List.member 1 model.levels && List.member 2 model.levels && List.member 3 model.levels then
        let
            text =
                model.text

            new_text =
                { text | president = [ "I have passed the three trials successfully!", "You are great. I am glad to inform you that you are submitted into Night!" ] }
        in
        { model | text = new_text }

    else
        model
