module OrderLanes(fromLists) where

import Control.Applicative
import Control.Monad.State

import qualified Lanes

type Coord = (Int,Int)
type Pos = State Coord

dist :: Coord -> Coord -> Int
dist (x,y) (x',y') = let two = 2 :: Int in (x-x')^two + (y-y')^two

dists :: Coord -> [Coord] -> Int
dists _ [] = 10000000
dists pos cs = maximum $ fmap (dist pos) cs

findPath :: [[[[Coord]]]] -> [[[[Coord]]]]
findPath = flip evalState (0,0) . mapM layer

layer :: [[[Coord]]] -> Pos [[[Coord]]]
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
        if dist' pos top <= dist' pos bot
            then mapM lane xs
            else mapM lane (reverse xs)

lane :: [[Coord]] -> Pos [[Coord]]
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

chord :: [Coord] -> Pos [Coord]
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

fromLists :: [[Int]] -> [[[[Coord]]]]
fromLists = findPath . Lanes.fromLists
