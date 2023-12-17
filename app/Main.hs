module Main (main) where

import Vec3
import Sphere
import Hittable
import Camera
import Utilities
import System.Random
import Data.Maybe (catMaybes)

randomLambert :: Vec3 -> StdGen -> (Sphere, StdGen)
randomLambert center g = (Sphere center 0.2 mat, g1)
    where
        (v, g1) = randomVec3 g
        mat = Lambertian v

randomMetal :: Vec3 -> StdGen -> (Sphere, StdGen)
randomMetal center g = (Sphere center 0.2 mat, g2)
    where
        (v, g1) = randomVec3 g
        (f, g2) = randomDouble g1
        mat = Metal v f

dielectric :: Vec3 -> Sphere
dielectric center = Sphere center 0.2 (Dielectric 1.5)

randomBall :: Int -> Int -> StdGen -> Maybe Sphere
randomBall a b g = 
    if lengthVec3 (center `minusVec3` (Vec3 4 0.2 0)) < 0.9
            then Nothing
            else Just sphere
                where
                    (chooseMat, g1) = randomDouble g
                    (x, g2) = randomDouble g1
                    (y, g3) = randomDouble g2
                    center = Vec3 (fromIntegral a + 0.9 * x) 0.2 (fromIntegral b + 0.9 * y)
                    (l, g4) = randomLambert center g3
                    (m, g5) = randomMetal center g4
                    sphere = if chooseMat < 0.8
                        then l
                        else
                            if chooseMat < 0.95
                                then m
                                else dielectric center

main :: IO ()
main = do
    let
        material_ground = Lambertian (Vec3 0.5 0.5 0.5)
        groundSphere = Sphere (Vec3 0 (-1000) 0) 1000 material_ground

        material1 = Dielectric 1.5
        material2 = Lambertian (Vec3 0.4 0.2 0.1)
        material3 = Metal (Vec3 0.7 0.6 0.5) 0.0

        sphere3 = Sphere (Vec3 0 1 0) 1.0 material1
        sphere2 = Sphere (Vec3 (-4) 1 0) 1.0 material2
        sphere1 = Sphere (Vec3 4 1 0) 1.0 material3

        world = HittableList ([sphere1, sphere2, sphere3] ++ [groundSphere])

        vFov = 20
        lookFrom = Vec3 13 2 3
        lookAt = Vec3 0 0 0
        vUp = Vec3 0 1 0

        -- world = HittableList (sortBy (distFromCamera lookFrom) l)
        -- world = HittableList l

        cam = initialize (16.0/9.0) 400 100 vFov lookFrom lookAt vUp

    renderInChunks cam world 10