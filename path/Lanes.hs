{-# LANGUAGE DeriveFunctor #-}

module Lanes (fromList, Dir(..), dir) where

-- permature optimization is the root of all evil
import Control.Applicative
import Data.Foldable
import qualified Data.List as List
import Prelude hiding (foldr, maximum)

data Dir = H | V deriving Show

type Position = (Int,Int)
data Dot a = Dot Position a deriving Functor

data Matrix a = Matrix { unMatrix :: [[Dot a]] } deriving Functor

instance Foldable Matrix where
    f `foldMap` lists = foldMap id $ foldMap unDot <$> unMatrix (fmap f lists)

dir :: Int -> Dir
dir = let dirs = H:V:dirs in (dirs!!)

unDot :: Dot a -> a
unDot (Dot _ x) = x

fromList :: [[Int]] -> [[[[Position]]]]
fromList = paths . makeMatrix

makeMatrix :: [[a]] -> Matrix a
makeMatrix list = let
        w = length list
        h = length (head list)
    in Matrix $ do
        x <- [0..w-1]
        [ do
        y <- [0..h-1]
        return $ Dot (x,y) (list !! x !! y)
        ]

transpose :: Matrix a -> Matrix a
transpose = Matrix . List.transpose . unMatrix

paths :: Matrix Int -> [[[[(Int,Int)]]]]
paths m = do
    z <- [0..maximum m - 1]
    return $ layer $ fmap (>z) $ case dir z of
        H -> transpose m
        V -> m

layer :: Matrix Bool -> [[[(Int,Int)]]]
layer = fmap lane . unMatrix

lane :: [Dot Bool] -> [[(Int,Int)]]
lane = lane' []
    where
    lane' :: [(Int,Int)] -> [Dot Bool] -> [[(Int,Int)]]
    lane' [] [] = []
    lane' xs [] = [reverse xs]
    lane' [] (Dot _ False:ds) = lane' [] ds
    lane' xs (Dot _ False:ds) = reverse xs:lane' [] ds
    lane' xs (Dot pos True:ds) = lane' (pos:xs) ds
