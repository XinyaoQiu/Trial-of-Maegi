module UpdateSTG exposing (updateSTG)

{-| This module is a submodule for [`Update.update`](Update#update), updating the STG part.


# Interface

@docs updateSTG

-}

import BulletGen exposing (bulletGen, selfBulletGen)
import Maybe exposing (..)
import Messages exposing (..)
import Model exposing (..)
import Vector exposing (..)


{-| -}
updateSTG : Int -> Msg -> Model -> Model
updateSTG level msg model =
    let
        character =
            model.character

        enemy =
            model.enemy

        bullets =
            model.bullets

        score =
            model.score

        isAlive =
            model.bullets
                |> List.filter (\nbullet -> checkCharacterhit model.character nbullet)
                |> List.isEmpty

        newCharacter =
            changeCharacter msg model

        newenemy =
            case msg of
                Tick elapsed ->
                    let
                        notBeHitten =
                            model.bullets
                                |> List.filter (\nbullet -> checkEnemyhit model.enemy nbullet)
                                |> List.isEmpty
                    in
                    if notBeHitten then
                        moveEnemy elapsed model.enemy model.bulletTime

                    else if enemy.life > 0 then
                        { enemy | life = enemy.life - 1 }

                    else
                        initEnemy

                _ ->
                    model.enemy

        ( bulletsgen, nseed ) =
            bulletGen level model.bulletTime model.character newenemy model.seed

        newbullets =
            case msg of
                Tick elapsed ->
                    (model.bullets
                        |> List.filter isVisible
                        |> List.filter (\nbullet -> not (checkCharacterhit model.character nbullet))
                        |> List.filter (\nbullet -> not (checkEnemyhit model.enemy nbullet))
                        |> List.map (changeBulletPos elapsed)
                    )
                        ++ bulletsgen
                        ++ selfBulletGen newCharacter enemy

                _ ->
                    bullets

        newscore =
            changeScore character enemy bullets msg score

        newcoin =
            if enemy.life == 0 then
                if model.trigertext == Magicfield then
                    model.coin + 1000

                else
                    2000 + newscore // 1000 + model.coin

            else if character.life == 0 then
                if model.trigertext == Magicfield then
                    model.coin

                else
                    newscore // 1000 + model.coin

            else
                model.coin

        newlevels =
            if enemy.life == 1 then
                level :: model.levels

            else
                model.levels
    in
    case msg of
        Tick elapsed ->
            case model.pause of
                Normal ->
                    { model
                        | bullets =
                            if isAlive then
                                newbullets

                            else
                                []
                        , round = model.round + 1
                        , bulletTime =
                            if elapsed > 7 then
                                model.bulletTime + 1

                            else if modBy 2 model.round == 0 then
                                model.bulletTime + 1

                            else
                                model.bulletTime
                        , character = newCharacter
                        , enemy = newenemy
                        , seed = nseed
                        , score = newscore
                        , levels = newlevels
                        , pause =
                            if newenemy.life == 0 then
                                Win newcoin

                            else if newCharacter.life == 0 then
                                Dead newcoin

                            else
                                Normal
                    }

                _ ->
                    { model
                        | pause =
                            if newenemy.life == 0 then
                                Win newcoin

                            else if newCharacter.life == 0 then
                                Dead newcoin

                            else
                                model.pause
                    }

        Restart ->
            { model
                | pause = Normal
                , bulletTime = 0
                , bullets = []
                , enemy =
                    case level of
                        1 ->
                            { initEnemy | life = 1000 }

                        2 ->
                            { initEnemy | life = 800 }

                        3 ->
                            { initEnemy | life = 1500 }

                        _ ->
                            initEnemy
                , character = { initCharacter1 | charactertype = character.charactertype }
                , score = 0
                , coin =
                    case model.pause of
                        Win coin ->
                            model.coin + coin

                        Dead coin ->
                            model.coin + coin

                        _ ->
                            model.coin
            }

        Exit ->
            { model
                | state = Rpg
                , trigertext = Object_
                , coin =
                    case model.pause of
                        Win coin ->
                            model.coin + coin

                        Dead coin ->
                            model.coin + coin

                        _ ->
                            model.coin
            }

        KeyDown 88 ->
            if newCharacter.bomb > 0 then
                { model | bullets = [], character = { newCharacter | bomb = newCharacter.bomb - 1 } }

            else
                model

        KeyDown 27 ->
            case model.pause of
                Pause ->
                    { model | pause = Normal }

                Normal ->
                    { model | pause = Pause }

                _ ->
                    model

        _ ->
            { model | character = newCharacter }


changeCharacter : Msg -> Model -> Character
changeCharacter msg model =
    let
        character =
            model.character

        enemy =
            model.enemy

        isAlive =
            model.bullets
                |> List.filter (\nbullet -> checkCharacterhit model.character nbullet)
                |> List.isEmpty
    in
    case msg of
        KeyDown 16 ->
            { character | slow = True }

        KeyDown 37 ->
            { character | moveL = True }

        KeyDown 38 ->
            { character | moveU = True }

        KeyDown 39 ->
            { character | moveR = True }

        KeyDown 40 ->
            { character | moveD = True }

        KeyDown 90 ->
            { character | shoot = True }

        KeyUp 16 ->
            { character | slow = False }

        KeyUp 37 ->
            { character | moveL = False }

        KeyUp 38 ->
            { character | moveU = False }

        KeyUp 39 ->
            { character | moveR = False }

        KeyUp 40 ->
            { character | moveD = False }

        KeyUp 90 ->
            { character | shoot = False }

        Tick elapsed ->
            let
                d =
                    (5 - 2.5 * toIdentity character.slow) * elapsed / 18

                x =
                    Tuple.first character.pos
                        - d
                        * toIdentity character.moveL
                        + d
                        * toIdentity character.moveR
                        |> max 30
                        |> min (canvasWidth - 30)

                y =
                    Tuple.second character.pos
                        - d
                        * toIdentity character.moveU
                        + d
                        * toIdentity character.moveD
                        |> max 30
                        |> min (canvasHeight - 30)

                nshootTime =
                    if character.shoot then
                        if elapsed > 7 then
                            character.shootTime + 1

                        else if modBy 2 model.round == 1 then
                            character.shootTime + 1

                        else
                            character.shootTime

                    else
                        0

                ( nx, ny ) =
                    if distance ( x, y ) enemy.pos <= 60 then
                        character.pos

                    else
                        ( x, y )
            in
            if isAlive then
                { character | pos = ( nx, ny ), shootTime = nshootTime }

            else if character.life > 0 then
                if model.trigertext == Magicfield then
                    { character | shootTime = nshootTime, pos = initCharacter1.pos }

                else
                    { character | life = character.life - 1, shootTime = nshootTime, pos = initCharacter1.pos }

            else
                character

        _ ->
            character


changeScore : Character -> Enemy -> List Bullet -> Msg -> Int -> Int
changeScore character enemy bullets msg score =
    let
        notBeHitten =
            bullets
                |> List.filter (\nbullet -> checkEnemyhit enemy nbullet)
                |> List.isEmpty

        isAlive =
            bullets
                |> List.filter (\nbullet -> checkCharacterhit character nbullet)
                |> List.isEmpty
    in
    if notBeHitten then
        if isAlive then
            case msg of
                KeyDown 88 ->
                    score - 500

                _ ->
                    score

        else
            case msg of
                KeyDown 88 ->
                    score - 500 - 20000

                _ ->
                    score - 20000

    else if isAlive then
        case msg of
            KeyDown 88 ->
                score - 500 + 321

            _ ->
                score + 321

    else
        case msg of
            KeyDown 88 ->
                max 0 (score - 500 - 20000 + 321)

            _ ->
                max 0 (score - 20000 + 321)


moveEnemy : Float -> Enemy -> Int -> Enemy
moveEnemy elapsed enemy bulletTime =
    if bulletTime >= 100 && bulletTime <= 200 then
        let
            ( x, y ) =
                enemy.pos

            ( nx, ny ) =
                ( x - (1.5 * elapsed / 20), y )
        in
        { enemy | pos = ( nx, ny ) }

    else if bulletTime > 200 && bulletTime <= 400 then
        let
            ( x, y ) =
                enemy.pos

            ( nx, ny ) =
                ( x, y + elapsed / 20 )
        in
        { enemy | pos = ( nx, ny ) }

    else if bulletTime > 2000 && bulletTime <= 2040 then
        let
            ( x, y ) =
                enemy.pos

            ( nx, ny ) =
                ( x, y - 5 * elapsed / 20 )
        in
        { enemy | pos = ( nx, ny ) }

    else if bulletTime >= 2600 && bulletTime <= 5000 then
        let
            ( dx, dy ) =
                substract ( 245, 100 ) enemy.pos

            v =
                multiply (1 / 2400) ( dx, dy )

            ( nx, ny ) =
                add enemy.pos v
        in
        { enemy | pos = ( nx, ny ) }

    else
        enemy


checkCharacterhit : Character -> Bullet -> Bool
checkCharacterhit character bullet =
    case bullet.shiptype of
        Self ->
            False

        Boss ->
            case bullet.shape of
                Circle r ->
                    r + 5 > distance bullet.pos character.pos

                Rect ( _, yy ) ->
                    let
                        ( sx, sy ) =
                            bullet.pos

                        ( dx, dy ) =
                            multiply yy (unit bullet.velocity)

                        ( cx, cy ) =
                            character.pos

                        t =
                            0.0 - (((sx - cx) * dx + (sy - cy) * dy) / (dx * dx + dy * dy))

                        t1 =
                            if t < 0 then
                                0

                            else if t > 1 then
                                1

                            else
                                t

                        dx1 =
                            (sx + t1 * dx) - cx

                        d1 =
                            sqrt (dx1 ^ 2 + dy ^ 2)
                    in
                    5 > d1

                Ellipse ( _, ry ) ->
                    let
                        ( dx, dy ) =
                            multiply ry (unit bullet.velocity)

                        ( sx, sy ) =
                            substract bullet.pos ( dx, dy )

                        ( cx, cy ) =
                            character.pos

                        t =
                            0 - (((sx - cx) * dx + (sy - cy) * dy) / (dx * dx + dy * dy))

                        t1 =
                            if t < 0 then
                                0

                            else if t > 1 then
                                1

                            else
                                t

                        dx1 =
                            (sx + t1 * dx) - cx

                        dy1 =
                            (sy + t1 * dy) - cy

                        d1 =
                            sqrt (dx1 ^ 2 + dy1 ^ 2)
                    in
                    d1 < 5


checkEnemyhit : Enemy -> Bullet -> Bool
checkEnemyhit enemy bullet =
    case bullet.shiptype of
        Boss ->
            False

        Self ->
            case bullet.shape of
                Circle r ->
                    r + enemy.r > distance bullet.pos enemy.pos

                Rect ( _, yy ) ->
                    let
                        ( sx, sy ) =
                            bullet.pos

                        ( dx, dy ) =
                            multiply yy (unit bullet.velocity)

                        ( cx, cy ) =
                            enemy.pos

                        t =
                            0 - (((sx - cx) * dx + (sy - cy) * dy) / (dx * dx + dy * dy))

                        t1 =
                            if t < 0 then
                                0

                            else if t > 1 then
                                1

                            else
                                t

                        dx1 =
                            (sx + t1 * dx) - cx

                        dy1 =
                            (sy + t1 * dy) - cy

                        d1 =
                            sqrt (dx1 ^ 2 + dy1 ^ 2)
                    in
                    d1 < enemy.r

                Ellipse ( _, ry ) ->
                    let
                        ( dx, dy ) =
                            multiply ry (unit bullet.velocity)

                        ( sx, sy ) =
                            substract bullet.pos ( dx, dy )

                        ( cx, cy ) =
                            enemy.pos

                        t =
                            0 - (((sx - cx) * dx + (sy - cy) * dy) / (dx * dx + dy * dy))

                        t1 =
                            if t < 0 then
                                0

                            else if t > 1 then
                                1

                            else
                                t

                        dx1 =
                            (sx + t1 * dx) - cx

                        dy1 =
                            (sy + t1 * dy) - cy

                        d1 =
                            sqrt (dx1 ^ 2 + dy1 ^ 2)
                    in
                    d1 < enemy.r



-- STG


changeBulletPos : Float -> Bullet -> Bullet
changeBulletPos elapsed bullet =
    let
        ( x, y ) =
            bullet.pos

        ( vx, vy ) =
            bullet.velocity
    in
    { bullet | pos = ( x + vx * elapsed / 18, y + vy * elapsed / 18 ) }


isVisible : Bullet -> Bool
isVisible bullet =
    let
        ( x, y ) =
            bullet.pos

        r =
            case bullet.shape of
                Circle r1 ->
                    r1

                Rect ( xx, yy ) ->
                    min xx yy

                Ellipse ( rx, ry ) ->
                    min rx ry
    in
    x + r >= -80 && x - r <= canvasWidth + 80 && y + r >= 0 && y - r <= canvasHeight && bullet.velocity /= ( 0, 0 )
