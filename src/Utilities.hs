module Utilities where
import System.Random

degreesToRadians :: Double -> Double
degreesToRadians deg = deg * pi / 180.0

randomDouble :: StdGen -> (Double, StdGen)
randomDouble = randomR (0.0, 1.0)

-- Function to generate a random double within a range
randomDoubleR :: Double -> Double -> StdGen -> (Double, StdGen)
randomDoubleR rand_min rand_max gen =
    let (randValue, newGen) = randomDouble gen
    in (rand_min + (rand_max - rand_min) * randValue, newGen)