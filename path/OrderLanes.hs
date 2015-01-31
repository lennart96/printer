module OrderLanes(fromList) where

import Control.Applicative
import Control.Monad.State

import qualified Lanes

type Coord = (Int,Int)
type Pos = State Coord
type Chord = [Coord]
type Lane = [Chord]
type Layer = [Lane]

fromList :: [[Int]] -> [[[[Coord]]]]
fromList = findPath . Lanes.fromList

dist :: Coord -> Coord -> Int
dist (x,y) (x',y') = let two = 2 :: Int in (x-x')^two + (y-y')^two

dists :: Coord -> Chord -> Int
dists _ [] = 10000000
dists pos xs = maximum $ fmap (dist pos) xs

distss :: Coord -> Lane -> Int
distss pos = dists pos . join

findPath :: [Layer] -> [Layer]
findPath = flip evalState (0,0) . mapM layer

layer :: Layer -> Pos Layer
layer [] = return []
layer [x] = (:[]) <$> lane x
layer xs' = let
        xs = simplify xs'
        top = head xs
        bot = last xs
        dist' :: Coord -> [[Coord]] -> Int
        dist' _ [] = dists undefined []
        dist' pos ls = minimum $ fmap (dists pos) ls
    in do
        pos <- get
        if dist' pos top > dist' pos bot
            then mapM lane xs
            else mapM lane (reverse xs)

lane :: Lane -> Pos Lane
lane [] = return []
lane [x] = (:[]) <$> chord x
lane xs' = let
        xs = simplify xs'
        top = head xs
        bot = last xs
    in do
        pos <- get
        if dists pos top < dists pos bot
            then mapM chord xs
            else mapM chord (reverse xs)

chord :: Chord -> Pos Chord
chord [] = return []
chord [x] = [x] <$ put x
chord xs = let
        top = head xs
        bot = last xs
    in do
        pos <- get
        if dist pos top <= dist pos bot
            then xs <$ put bot
            else reverse xs <$ put top

simplify :: [[a]] -> [[a]]
simplify [] = []
simplify ([]:xs) = simplify xs
simplify (x:xs) = x:simplify xs
