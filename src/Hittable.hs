module Hittable where

import Vec3
import Ray
import Data.Maybe (fromMaybe)
data HitRecord = HitRecord { p :: Vec3, n :: Vec3, t :: Double, front_face :: Bool }

setFaceNormal :: Ray -> Vec3 -> HitRecord -> HitRecord
setFaceNormal r outward_normal original =
  HitRecord (p original) new_normal (t original) new_front_face
    where
      new_front_face = (((direction r) `dot` outward_normal) < 0)
      new_normal = case new_front_face of
        True -> outward_normal
        False -> negateVec3 outward_normal

class Hittable a where
  hit :: Ray -> Double -> Double -> Maybe HitRecord -> a -> Maybe HitRecord

newtype HittableList a = HittableList [a]

-- clearHittableList :: HittableList
-- clearHittableList = HittableList []

-- addHittableList :: HittableList -> a -> HittableList
-- addHittableList (HittableList l) h = HittableList (l : h)


instance Hittable a => Hittable (HittableList a) where
    hit ray tmin tmax record (HittableList items) = record
        where
            reduce i (r, current_max) = fromMaybe (r, current_max) m
                where
                    m = do
                        record <- hit ray tmin current_max record i
                        return (Just record, t record)
            record = fst $ foldr reduce (Nothing, tmax) items

-- instance Hittable a => Hittable (HittableList a) where
--     hit r ray_tmin ray_tmax (HittableList objects) = record
--         where
--             reduce i (r', current_max) = fromMaybe (r, current_max) m
--                 where
--                     m = do
--                         record <- hit r ray_tmin current_max i
--                         return (Just record, t record)
--             record = fst $ foldr reduce (Nothing, ray_tmax) objects
            