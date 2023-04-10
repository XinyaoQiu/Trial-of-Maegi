module BulletGen exposing (bulletGen, selfBulletGen)

{-| This module illustrate the behavior of bullets in STG.


# Interface

@docs bulletGen, selfBulletGen

-}

import Messages exposing (..)
import Model exposing (..)
import Random
import Vector exposing (..)


{-| Generate bullets of the player.
-}
selfBulletGen : Character -> Enemy -> List Bullet
selfBulletGen character enemy =
    case character.charactertype of
        A ->
            selfBulletGenA character enemy

        B ->
            selfBulletGenB character enemy

        C ->
            selfBulletGenC character enemy

        _ ->
            selfBulletGenA character enemy


selfBulletGenA : Character -> Enemy -> List Bullet
selfBulletGenA character enemy =
    let
        shoot =
            character.shoot

        ( x, y ) =
            character.pos

        bullet1 =
            if character.slow then
                Bullet ( x + 10, y - 70 ) ( 0, -20 ) Self (Ellipse ( 3, 30 )) "#96FED1"

            else
                Bullet ( x + 40, y - 70 ) ( 1, -20 ) Self (Ellipse ( 3, 30 )) "#96FED1"

        bullet2 =
            if character.slow then
                Bullet ( x - 10, y - 70 ) ( 0, -20 ) Self (Ellipse ( 3, 30 )) "#96FED1"

            else
                Bullet ( x - 40, y - 70 ) ( -1, -20 ) Self (Ellipse ( 3, 30 )) "#96FED1"

        bullet3 =
            if character.slow then
                Bullet ( x + 20, y - 50 ) ( 0, -10 ) Self (Ellipse ( 3, 20 )) "#F1E1FF"

            else
                Bullet ( x + 70, y ) ( 2, -10 ) Self (Ellipse ( 3, 20 )) "#F1E1FF"

        bullet4 =
            if character.slow then
                Bullet ( x - 20, y - 50 ) ( 0, -10 ) Self (Ellipse ( 3, 20 )) "#F1E1FF"

            else
                Bullet ( x - 70, y ) ( -2, -10 ) Self (Ellipse ( 3, 20 )) "#F1E1FF"

        bullet5 =
            if character.slow then
                Bullet ( x, y - 80 ) ( 0, -20 ) Self (Ellipse ( 3, 30 )) "#F1E1FF"

            else
                Bullet ( x, y - 80 ) ( 0, -20 ) Self (Ellipse ( 3, 30 )) "#F1E1FF"

        shootTime =
            character.shootTime
    in
    case modBy 5 shootTime of
        1 ->
            if enemy.life > 500 then
                if shoot then
                    [ bullet1, bullet2, bullet5 ]

                else
                    []

            else if shoot then
                [ bullet1, bullet2, bullet3, bullet4, bullet5 ]

            else
                []

        _ ->
            []


selfBulletGenB : Character -> Enemy -> List Bullet
selfBulletGenB character enemy =
    let
        shoot =
            character.shoot

        ( x, y ) =
            character.pos

        direction1 =
            unit (substract enemy.pos ( x + 20, y - 50 ))

        direction2 =
            unit (substract enemy.pos ( x - 20, y - 50 ))

        bullet1 =
            if character.slow then
                Bullet ( x + 10, y - 70 ) ( 0, -10 ) Self (Ellipse ( 5, 20 )) "#F6AED1"

            else
                Bullet ( x + 40, y - 70 ) ( 1, -10 ) Self (Ellipse ( 5, 20 )) "#F6AED1"

        bullet2 =
            if character.slow then
                Bullet ( x - 10, y - 70 ) ( 0, -10 ) Self (Ellipse ( 5, 20 )) "#F6AED1"

            else
                Bullet ( x - 40, y - 70 ) ( -1, -10 ) Self (Ellipse ( 5, 20 )) "#F6AED1"

        bullet3 =
            if character.slow then
                Bullet ( x + 20, y - 50 ) (multiply 5 direction1) Self (Ellipse ( 2, 15 )) "#F0FEFF"

            else
                Bullet ( x + 70, y ) (multiply 5 direction1) Self (Ellipse ( 2, 15 )) "#F0FEFF"

        bullet4 =
            if character.slow then
                Bullet ( x - 20, y - 50 ) (multiply 5 direction2) Self (Ellipse ( 2, 15 )) "#F0FEFF"

            else
                Bullet ( x - 70, y ) (multiply 5 direction2) Self (Ellipse ( 2, 15 )) "#F0FEFF"

        bullet5 =
            if character.slow then
                Bullet ( x, y - 80 ) ( 0, -10 ) Self (Ellipse ( 3, 30 )) "#A1010F"

            else
                Bullet ( x, y - 80 ) ( 0, -10 ) Self (Ellipse ( 3, 30 )) "#A1010F"

        shootTime =
            character.shootTime
    in
    case modBy 8 shootTime of
        1 ->
            if enemy.life > 400 then
                if shoot then
                    [ bullet1, bullet2, bullet5 ]

                else
                    []

            else if shoot then
                [ bullet1, bullet2, bullet3, bullet4, bullet5 ]

            else
                []

        _ ->
            []


selfBulletGenC : Character -> Enemy -> List Bullet
selfBulletGenC character enemy =
    let
        shoot =
            character.shoot

        ( x, y ) =
            character.pos

        bullet1 =
            if character.slow then
                Bullet ( x + 10, y - 70 ) ( 0, -7 ) Self (Ellipse ( 2, 3 )) "#F1F001"

            else
                Bullet ( x + 40, y - 70 ) ( 1, -7 ) Self (Ellipse ( 2, 3 )) "#F1F001"

        bullet2 =
            if character.slow then
                Bullet ( x - 10, y - 70 ) ( 0, -7 ) Self (Ellipse ( 2, 3 )) "#F1F001"

            else
                Bullet ( x - 40, y - 70 ) ( -1, -7 ) Self (Ellipse ( 2, 3 )) "#F1F001"

        bullet3 =
            if character.slow then
                Bullet ( x + 20, y - 50 ) ( 0, -720 ) Self (Rect ( 15, 720 )) "#FFF7FF"

            else
                Bullet ( x + 70, y ) ( 0, -720 ) Self (Rect ( 15, 720 )) "#FFF7FF"

        bullet4 =
            if character.slow then
                Bullet ( x - 20, y - 50 ) ( 0, -720 ) Self (Rect ( 15, 720 )) "#FFF7FF"

            else
                Bullet ( x - 70, y ) ( 0, -720 ) Self (Rect ( 15, 720 )) "#FFF7FF"

        bullet5 =
            if character.slow then
                Bullet ( x, y - 80 ) ( 0, -10 ) Self (Ellipse ( 3, 4 )) "#472728"

            else
                Bullet ( x, y - 80 ) ( 0, -10 ) Self (Ellipse ( 3, 4 )) "#472728"

        shootTime =
            character.shootTime
    in
    case modBy 2 shootTime of
        1 ->
            if enemy.life > 600 then
                if shoot then
                    [ bullet1, bullet2, bullet5 ]

                else
                    []

            else if shoot then
                [ bullet1, bullet2, bullet3, bullet4, bullet5 ]

            else
                []

        _ ->
            []


{-| Generate bullets of the enemy.
-}
bulletGen : Int -> Int -> Character -> Enemy -> Random.Seed -> ( List Bullet, Random.Seed )
bulletGen level =
    case level of
        1 ->
            bulletGen1

        2 ->
            bulletGen2

        3 ->
            bulletGen3

        _ ->
            always ( [], seed0 ) |> always |> always |> always


bulletGen1 : Int -> Character -> Enemy -> Random.Seed -> ( List Bullet, Random.Seed )
bulletGen1 bulletTime character enemy seed =
    let
        l =
            []

        ( randBulletList11, seed1 ) =
            randomBulletGen11 bulletTime seed []
    in
    if bulletTime <= 5000 then
        ( l
            ++ randBulletList11
            |> linebulletGen11 bulletTime enemy
            |> aimingBulletGen11 bulletTime character enemy
            |> spiralbulletGen11 bulletTime
        , seed1
        )

    else
        bulletGen1 (bulletTime - 5000) character enemy seed


bulletGen2 : Int -> Character -> Enemy -> Random.Seed -> ( List Bullet, Random.Seed )
bulletGen2 bulletTime character enemy seed =
    let
        l =
            []

        ( _, seed1 ) =
            randomBulletGen11 bulletTime seed []
    in
    if bulletTime <= 5000 then
        ( l
            |> aimingBulletGen21 bulletTime character enemy
            |> spiralbulletGen21 bulletTime
            |> spiralbulletGen12 bulletTime
            |> linebulletGen12 bulletTime enemy
        , seed1
        )

    else
        bulletGen2 (bulletTime - 5000) character enemy seed


bulletGen3 : Int -> Character -> Enemy -> Random.Seed -> ( List Bullet, Random.Seed )
bulletGen3 bulletTime character enemy seed =
    let
        l =
            []

        ( _, seed1 ) =
            randomBulletGen11 bulletTime seed []
    in
    if bulletTime <= 5000 then
        ( l
            |> aimingBulletGen31 bulletTime character
            |> spiralbulletGen31 bulletTime
            |> linebulletGen31 bulletTime enemy
            |> flowerBulletGen31 bulletTime
        , seed1
        )

    else
        bulletGen3 (bulletTime - 5000) character enemy seed


linebulletGen11 : Int -> Enemy -> List Bullet -> List Bullet
linebulletGen11 bulletTime enemy l =
    let
        ( x, y ) =
            enemy.pos

        bullet1 =
            Bullet ( x, y ) ( 1, 2 ) Boss (Circle 3) "#FF0000"

        bullet2 =
            Bullet ( x, y ) ( 1, 2 ) Boss (Circle 3) "#AAAAAA"
    in
    if bulletTime >= 50 && bulletTime <= 800 && modBy 50 (bulletTime - 50) == 0 then
        l ++ lineBulletGen bullet1 36 []

    else if bulletTime > 2800 && bulletTime <= 3300 && modBy 40 (bulletTime - 2400) == 0 then
        l ++ lineBulletGen bullet1 36 []

    else if bulletTime > 3600 && bulletTime <= 5000 && modBy 70 (bulletTime - 3600) == 0 then
        l ++ lineBulletGen bullet2 36 []

    else
        l


linebulletGen31 : Int -> Enemy -> List Bullet -> List Bullet
linebulletGen31 bulletTime enemy l =
    let
        ( x, y ) =
            enemy.pos

        bullet =
            Bullet ( x, y ) ( 2, 2 ) Boss (Circle 5) "#FFAA00"
    in
    if bulletTime >= 50 && bulletTime <= 800 && modBy 40 (bulletTime - 50) == 0 then
        l ++ lineBulletGen bullet 36 []

    else if bulletTime > 2400 && bulletTime <= 3000 && modBy 40 (bulletTime - 2400) == 0 then
        l ++ lineBulletGen bullet 36 []

    else if bulletTime > 4400 && bulletTime <= 5000 && modBy 40 (bulletTime - 4400) == 0 then
        l ++ lineBulletGen bullet 36 []

    else
        l


linebulletGen12 : Int -> Enemy -> List Bullet -> List Bullet
linebulletGen12 bulletTime enemy l =
    let
        ( x, y ) =
            enemy.pos

        bullet1 =
            Bullet ( x, y ) ( 1, 2 ) Boss (Ellipse ( 3, 10 )) "#1A0FF0"

        bullet2 =
            Bullet ( x, y ) ( 2, 2 ) Boss (Ellipse ( 3, 10 )) "#1A0FF0"
    in
    if bulletTime >= 3000 && bulletTime <= 4200 && modBy 100 (bulletTime - 3000) == 0 then
        l ++ lineBulletGen bullet1 36 [] ++ lineBulletGen bullet2 36 []

    else
        l


lineBulletGen : Bullet -> Int -> List Bullet -> List Bullet
lineBulletGen initbullet ways result =
    let
        ( dx, dy ) =
            initbullet.velocity

        speed =
            sqrt (dx ^ 2 + dy ^ 2)
    in
    case ways of
        0 ->
            result

        1 ->
            initbullet :: result

        _ ->
            if modBy 2 ways == 1 then
                let
                    theta =
                        pi / 18 * toFloat (ways // 2)

                    alpha =
                        atan2 dy dx

                    bullet1 =
                        { initbullet | velocity = ( speed * cos (alpha + theta), speed * sin (alpha + theta) ) }

                    bullet2 =
                        { initbullet | velocity = ( speed * cos (alpha - theta), speed * sin (alpha - theta) ) }
                in
                lineBulletGen initbullet (ways - 2) ([ bullet1, bullet2 ] ++ result)

            else
                let
                    theta =
                        pi / 18 * toFloat (ways // 2) - pi / 36

                    alpha =
                        atan2 dy dx

                    bullet1 =
                        { initbullet | velocity = ( speed * cos (alpha + theta), speed * sin (alpha + theta) ) }

                    bullet2 =
                        { initbullet | velocity = ( speed * cos (alpha - theta), speed * sin (alpha - theta) ) }
                in
                lineBulletGen initbullet (ways - 2) ([ bullet1, bullet2 ] ++ result)


spiralbulletGen11 : Int -> List Bullet -> List Bullet
spiralbulletGen11 bulletTime l =
    if bulletTime >= 1700 && bulletTime <= 2500 && modBy 4 (bulletTime - 1700) == 0 then
        let
            x =
                50 * cos (toFloat bulletTime / 20) + 245

            y =
                50 * sin (toFloat bulletTime / 20) + 360

            bullet =
                Bullet ( x, y ) ( 1, 2 ) Boss (Circle 3) "#EEAE00"

            ( dx, dy ) =
                bullet.velocity

            alpha =
                atan2 dy dx

            speed =
                sqrt (dx ^ 2 + dy ^ 2)

            v =
                ( speed * cos (alpha + 4 * pi / 51 * toFloat ((bulletTime - 800) // 2)), speed * sin (alpha + 4 * pi / 51 * toFloat ((bulletTime - 800) // 2)) )

            nbullet =
                { bullet | velocity = v }
        in
        nbullet :: l

    else
        l


spiralbulletGen12 : Int -> List Bullet -> List Bullet
spiralbulletGen12 bulletTime l =
    if bulletTime >= 1800 && bulletTime <= 3200 && modBy 1 (bulletTime - 1800) == 0 then
        let
            x =
                100 * cos (toFloat bulletTime / 2) + 245

            y =
                100 * sin (toFloat bulletTime / 2) + 360

            bullet =
                Bullet ( x, y ) ( 1, 2 ) Boss (Circle 3) "#EEEE00"

            ( dx, dy ) =
                bullet.velocity

            alpha =
                atan2 dy dx

            speed =
                sqrt (dx ^ 2 + dy ^ 2)

            v =
                ( speed * cos (alpha + 4 * pi / 51 * toFloat ((bulletTime - 800) // 2)), speed * sin (alpha + 4 * pi / 51 * toFloat ((bulletTime - 800) // 2)) )

            nbullet =
                { bullet | velocity = v }
        in
        nbullet :: l

    else
        l


spiralbulletGen21 : Int -> List Bullet -> List Bullet
spiralbulletGen21 bulletTime l =
    if bulletTime >= 700 && bulletTime <= 1800 && modBy 8 (bulletTime - 700) == 0 then
        let
            x =
                100 * cos (toFloat bulletTime / 200) + 245

            y =
                50 * sin (toFloat bulletTime / 200) + 360

            bullet =
                Bullet ( x, y ) ( 1, 5 ) Boss (Ellipse ( 2, 4 )) "#E0EFF0"

            ( dx, dy ) =
                bullet.velocity

            alpha =
                atan2 dy dx

            speed =
                sqrt (dx ^ 2 + dy ^ 2)

            v =
                ( speed * cos (alpha + 4 * pi / 30 * toFloat ((bulletTime - 800) // 10)), speed * sin (alpha + 4 * pi / 30 * toFloat ((bulletTime - 800) // 10)) )

            nbullet =
                { bullet | velocity = v }
        in
        nbullet :: l

    else
        l


spiralbulletGen31 : Int -> List Bullet -> List Bullet
spiralbulletGen31 bulletTime l =
    if bulletTime >= 3400 && bulletTime <= 4600 && modBy 2 (bulletTime - 3400) == 0 then
        let
            x =
                50 * cos (toFloat bulletTime / 100) + 245

            y =
                50 * sin (toFloat bulletTime / 100) + 360

            bullet =
                Bullet ( x, y ) ( 1, 5 ) Boss (Ellipse ( 4, 10 )) "#AAAAF0"

            ( dx, dy ) =
                bullet.velocity

            alpha =
                atan2 dy dx

            speed =
                sqrt (dx ^ 2 + dy ^ 2)

            v =
                ( speed * cos (alpha + 4 * pi / 30 * toFloat (bulletTime - 3400)), speed * sin (alpha + 4 * pi / 30 * toFloat (bulletTime - 3400)) )

            nbullet =
                { bullet | velocity = v }
        in
        nbullet :: l

    else
        l


flowerBulletGen31 : Int -> List Bullet -> List Bullet
flowerBulletGen31 bulletTime l =
    let
        bullet =
            Bullet ( 245, 360 ) ( 1, 1 ) Boss (Circle 2) "#F9FAA0"
    in
    l ++ fBGen1Helper bullet 8 bulletTime []


fBGen1Helper : Bullet -> Int -> Int -> List Bullet -> List Bullet
fBGen1Helper initbullet index bulletTime result =
    let
        ( x, y ) =
            initbullet.pos

        ( dx, dy ) =
            initbullet.velocity

        speed =
            sqrt (dx ^ 2 + dy ^ 2)

        theta =
            pi / 4 * toFloat (index - 1)

        newbullet2 =
            { initbullet
                | pos =
                    ( x + speed * toFloat 100 * cos theta
                    , y + speed * toFloat 100 * sin theta
                    )
                , velocity = ( 0, speed )
            }

        newbullets2 =
            lineBulletGen newbullet2 36 []
    in
    if bulletTime >= 600 && bulletTime <= 1800 then
        if modBy 160 (bulletTime - 600) == 0 then
            case index of
                1 ->
                    newbullets2 ++ result

                _ ->
                    fBGen1Helper initbullet (index - 1) bulletTime (newbullets2 ++ result)

        else
            []

    else
        []


aimingBulletGen : Bullet -> Character -> Bullet
aimingBulletGen initbullet character =
    let
        ( x, y ) =
            initbullet.pos

        ( cx, cy ) =
            character.pos

        ( vx, vy ) =
            initbullet.velocity

        speed =
            sqrt (vx ^ 2 + vy ^ 2)

        direction =
            unit ( cx - x, cy - y )

        v =
            multiply speed direction
    in
    { initbullet | velocity = v }


aimingBulletGen11 : Int -> Character -> Enemy -> List Bullet -> List Bullet
aimingBulletGen11 bulletTime character enemy l =
    let
        ( x, y ) =
            enemy.pos

        bullet1 =
            Bullet ( x, y ) ( 0, 3 ) Boss (Circle 5) "#C22368"

        bullet2 =
            Bullet ( 100, 100 ) ( 0, 2 ) Boss (Ellipse ( 2, 6 )) "#CD96CD"

        bullet3 =
            Bullet ( 390, 100 ) ( 0, 2 ) Boss (Ellipse ( 2, 6 )) "#CD96CD"
    in
    if bulletTime >= 1050 && bulletTime <= 1550 && modBy 60 (bulletTime - 1050) == 0 then
        lineBulletGen (aimingBulletGen bullet1 character) 5 [] ++ l

    else if bulletTime >= 2000 && bulletTime <= 2800 && modBy 30 (bulletTime - 2000) == 0 then
        lineBulletGen (aimingBulletGen bullet1 character) 3 [] ++ l

    else if bulletTime >= 3000 && bulletTime <= 4500 && modBy 30 (bulletTime - 3000) == 0 then
        l ++ lineBulletGen (aimingBulletGen bullet2 character) 2 [] ++ lineBulletGen (aimingBulletGen bullet3 character) 2 []

    else
        l


aimingBulletGen21 : Int -> Character -> Enemy -> List Bullet -> List Bullet
aimingBulletGen21 bulletTime character enemy l =
    let
        ( x, y ) =
            enemy.pos

        bullet1 =
            Bullet ( x, y ) ( 0, 3 ) Boss (Circle 40) "#FFF000"

        bullet2 =
            Bullet enemy.pos ( 0, 4 ) Boss (Ellipse ( 2, 6 )) "#CD16CD"

        bullet3 =
            Bullet enemy.pos ( 0, 4 ) Boss (Ellipse ( 2, 6 )) "#CFF6CD"
    in
    if bulletTime >= 150 && bulletTime <= 1500 && modBy 200 (bulletTime - 150) == 0 then
        lineBulletGen (aimingBulletGen bullet1 character) 1 [] ++ l

    else if bulletTime > 50 && bulletTime <= 800 && modBy 10 (bulletTime - 50) == 0 then
        lineBulletGen (aimingBulletGen bullet2 character) 1 [] ++ l

    else if bulletTime > 4300 && bulletTime <= 5000 && modBy 10 (bulletTime - 4000) == 0 then
        lineBulletGen (aimingBulletGen bullet3 character) 3 [] ++ l

    else
        l


aimingBulletGen31 : Int -> Character -> List Bullet -> List Bullet
aimingBulletGen31 bulletTime character l =
    let
        bullet1 =
            Bullet ( 0, 0 ) ( 0, 3 ) Boss (Ellipse ( 4, 6 )) "#CD16CD"

        bullet2 =
            Bullet ( 0, 720 ) ( 0, 3 ) Boss (Ellipse ( 4, 6 )) "#CD16CD"

        bullet3 =
            Bullet ( 480, 0 ) ( 0, 3 ) Boss (Ellipse ( 4, 6 )) "#CD16CD"

        bullet4 =
            Bullet ( 480, 720 ) ( 0, 3 ) Boss (Ellipse ( 4, 6 )) "#CD16CD"
    in
    if bulletTime >= 2200 && bulletTime <= 3000 && modBy 40 (bulletTime - 2500) == 0 then
        l
            ++ lineBulletGen (aimingBulletGen bullet1 character) 1 []
            ++ lineBulletGen (aimingBulletGen bullet2 character) 1 []
            ++ lineBulletGen (aimingBulletGen bullet3 character) 1 []
            ++ lineBulletGen (aimingBulletGen bullet4 character) 1 []

    else
        l


random : Random.Seed -> ( ( Float, Float ), Random.Seed )
random seed =
    let
        ( x, seed1 ) =
            Random.step (Random.float 30 690) seed

        ( y, seed2 ) =
            Random.step (Random.float 1 5) seed1
    in
    ( ( x, y ), seed2 )


randomBulletGen11 : Int -> Random.Seed -> List Bullet -> ( List Bullet, Random.Seed )
randomBulletGen11 bulletTime seed l =
    let
        ( ( x, vy ), nseed ) =
            random seed

        bullet =
            Bullet ( x, 0 ) ( 0, vy ) Boss (Ellipse ( 6, 16 )) "#ADD8E0"
    in
    if bulletTime >= 1000 && bulletTime <= 1600 && modBy 20 bulletTime == 0 then
        ( bullet :: l, nseed )

    else
        ( l, nseed )
