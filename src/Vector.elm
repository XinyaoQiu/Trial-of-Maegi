module Vector exposing
    ( Vector
    , add, substract, multiply, dot, norm, distance, unit
    )

{-| This module defines `Vector` and implement operations for basic vector calculations.


# Definition

@docs Vector


# Operations

@docs add, substract, multiply, dot, norm, distance, unit

-}


{-| Tuple alias to represent a two-dimensional vector.
-}
type alias Vector =
    ( Float, Float )


{-| Addition between two vectors.
-}
add : Vector -> Vector -> Vector
add v1 v2 =
    let
        ( x1, y1 ) =
            v1

        ( x2, y2 ) =
            v2
    in
    ( x1 + x2, y1 + y2 )


{-| Substraction between two vectors.
-}
substract : Vector -> Vector -> Vector
substract v1 v2 =
    let
        ( x1, y1 ) =
            v1

        ( x2, y2 ) =
            v2
    in
    ( x1 - x2, y1 - y2 )


{-| Scalar product for vectors.
-}
multiply : Float -> Vector -> Vector
multiply a v =
    let
        ( x1, y1 ) =
            v
    in
    ( a * x1, a * y1 )


{-| Inner product between two vectors.
-}
dot : Vector -> Vector -> Float
dot v1 v2 =
    let
        ( x1, y1 ) =
            v1

        ( x2, y2 ) =
            v2
    in
    x1 * x2 + y1 * y2


{-| Norm of a vector.
-}
norm : Vector -> Float
norm v =
    sqrt (dot v v)


{-| Distance between two vectors.
-}
distance : ( Float, Float ) -> ( Float, Float ) -> Float
distance v1 v2 =
    norm (substract v1 v2)


{-| Find the corresponding unit vector of a non-zero vector.
-}
unit : Vector -> Vector
unit v =
    multiply (1 / norm v) v
