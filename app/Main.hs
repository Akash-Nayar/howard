module Main (main) where

import Vec3
import Sphere
import Hittable
import Camera


main :: IO ()
main = do
    let
        world = HittableList [Sphere (Vec3 0 0 (-1)) 0.5 (Lambertian (Vec3 0 0 0)), Sphere (Vec3 0 (-100.5) (-1)) 100 (Lambertian (Vec3 0 0 0))]

        cam = initialize (16.0/9.0) 400 100

    render cam world

