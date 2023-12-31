module Vec3(
    Vec3 (Vec3),
    x,
    y,
    z,
    negateVec3,
    addVec3,
    minusVec3,
    multiplyVec3,
    divideVec3,
    lengthSquaredVec3,
    lengthVec3,
    unitVector,
    dot,
    cross,
    randomVec3,
    randomUnitVector,
    nearZero,
    reflect,
    refract
) where

import System.Random
import Utilities

data Vec3 = Vec3
    {
        x :: Double,
        y :: Double,
        z :: Double
    } deriving (Show)

negateVec3 :: Vec3 -> Vec3
negateVec3 (Vec3 x' y' z') = Vec3 (-x') (-y') (-z')

addVec3 :: Vec3 -> Vec3 -> Vec3
addVec3 (Vec3 u1 u2 u3) (Vec3 v1 v2 v3) = Vec3 (u1 + v1) (u2 + v2) (u3 + v3)

class MultiplyVec3 a where
    multiplyVec3 :: Vec3 -> a -> Vec3

instance MultiplyVec3 Double where
    multiplyVec3 (Vec3 x' y' z') t = Vec3 (x' * t) (y' * t) (z' * t)

instance MultiplyVec3 Vec3 where
    multiplyVec3 (Vec3 a b c) (Vec3 x' y' z')  = Vec3 (a * x') (b * y') (c * z')

minusVec3 :: Vec3 -> Vec3 -> Vec3
minusVec3 (Vec3 u1 u2 u3) (Vec3 v1 v2 v3) = Vec3 (u1 - v1) (u2 - v2) (u3 - v3)

divideVec3 :: Vec3 -> Double -> Vec3
divideVec3 v t = multiplyVec3 v (1 / t)

lengthSquaredVec3 :: Vec3 -> Double
lengthSquaredVec3 (Vec3 x' y' z') = x' * x' + y' * y' + z' * z'

lengthVec3 :: Vec3 -> Double
lengthVec3 v = sqrt (lengthSquaredVec3 v)

unitVector :: Vec3 -> Vec3
unitVector v = v `divideVec3` lengthVec3 v

dot :: Vec3 -> Vec3 -> Double
dot (Vec3 u1 u2 u3) (Vec3 v1 v2 v3) = (u1 * v1) + (u2 * v2) + (u3 * v3)

cross :: Vec3 -> Vec3 -> Vec3
cross (Vec3 a1 a2 a3) (Vec3 b1 b2 b3) = Vec3 (a2 * b3 - a3 * b2) (a3 * b1 - a1 * b3) (a1 * b2 - a2 * b1)

randomVec3 :: StdGen -> (Vec3, StdGen)
randomVec3 = randomVec3R 0.0 1.0

randomVec3R :: Double -> Double -> StdGen -> (Vec3, StdGen)
randomVec3R rand_min rand_max g =
    ((Vec3 x' y' z'), g3)
        where
            (x', g1) = randomDoubleR rand_min rand_max g
            (y', g2) = randomDoubleR rand_min rand_max g1
            (z', g3) = randomDoubleR rand_min rand_max g2

randomInUnitSphere :: StdGen -> (Vec3, StdGen)
randomInUnitSphere g 
 | lengthSquaredVec3 v <= 1 = (v, g1)
 | otherwise = randomInUnitSphere g1 
    where
        (v, g1) = randomVec3R (-1.0 ) 1.0 g

randomUnitVector :: StdGen -> (Vec3, StdGen)
randomUnitVector g = (unitVector v, g1)
    where
        (v, g1) = randomInUnitSphere g

nearZero :: Vec3 -> Bool
nearZero (Vec3 a b c) = 
    (abs a < s) && (abs b < s) && (abs c < s)
        where s = 1e-8

reflect :: Vec3 -> Vec3 -> Vec3
reflect v n = v `minusVec3` (n `multiplyVec3` (2 * (v `dot` n)))

refract :: Vec3 -> Vec3 -> Double -> Vec3
refract uv n refrac = rOutPerp `addVec3` rOutParallel
                    where 
                        cosTheta = min (negateVec3 uv `dot` n) 1.0
                        rOutPerp = (uv `addVec3` (n `multiplyVec3` cosTheta)) `multiplyVec3` refrac
                        rOutParallel = n `multiplyVec3` ((-1) * sqrt (abs (1.0 - (lengthSquaredVec3 rOutPerp))))
