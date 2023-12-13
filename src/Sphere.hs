module Sphere where

import Vec3
import Ray
import Hittable
import Interval
data Sphere = Sphere { center :: Vec3, radius :: Double, material :: Material}

instance Hittable Sphere where
    hit r range record s =
        let oc = origin r `minusVec3` center s
            a = direction r `dot` direction r
            half_b = dot oc (direction r)
            c = (oc `dot` oc) - (radius s * radius s)
            discriminant = half_b * half_b - a * c

            checkRoot :: Double -> Bool
            checkRoot root = surrounds root range

            updateHitRecord :: Double -> HitRecord -> HitRecord
            updateHitRecord root (HitRecord p n (Material s1) t f) =
                let hit_point = origin r `addVec3` (direction  r`multiplyVec3` root)
                    hit_normal = (hit_point `minusVec3` center s) `divideVec3` radius s
                    outward_normal = (p `minusVec3` center s) `divideVec3` radius s
                    new_front_face = maybe False front_face record
                in setFaceNormal r outward_normal (HitRecord hit_point hit_normal (Material s1) root new_front_face)

        in if discriminant < 0
            then Nothing
            else
                let sqrtd = sqrt discriminant
                    root1 = (-half_b - sqrtd) / a
                    root2 = (-half_b + sqrtd) / a

                    validRoot1 = checkRoot root1
                    validRoot2 = checkRoot root2
                    new_front_face = maybe False front_face record

                    new_record = case record of
                        Nothing -> HitRecord (Vec3 0 0 0) (Vec3 0 0 0) (Material s) 0 False
                        Just real_record -> real_record


                in case (validRoot1, validRoot2) of
                    (True, _) -> Just $ updateHitRecord root1 (HitRecord (p new_record) (n new_record) (Material s) root1 new_front_face)
                    (_, True) -> Just $ updateHitRecord root2 (HitRecord (p new_record) (n new_record) (Material s) root2 new_front_face)
                    _ -> Nothing


            -- let
        --     oc = origin r `minusVec3` (center s)
        --     a = direction r `dot` direction r
        --     half_b = oc `dot` direction r
        --     c = (oc `dot` oc) - (radius s * radius s)
        --     discriminant = half_b*half_b - a*c



hitSphere :: Vec3 -> Double -> Ray -> Double
hitSphere center radius ray =
                            let
                                oc = origin ray `minusVec3` center
                                a = direction ray `dot` direction ray
                                b = 2.0 * (oc `dot` direction ray)
                                c = (oc `dot` oc) - (radius * radius)
                                discriminant = b*b - 4*a*c
                            in
                                if discriminant < 0
                                    then -1.0
                                    else (-b - sqrt discriminant) / (2.0 * a)


