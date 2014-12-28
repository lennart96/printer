module Path(findPath,Cmd(..)) where

import Control.Applicative
import Control.Monad.State
import Control.Monad.Trans.Writer
import Data.Maybe (maybeToList)

import Lanes (Dir(H,V),dir)
import qualified OrderLanes

data Cmd = N Int | E Int | S Int | W Int | Up | On | Off deriving Show
type Coord = (Int,Int,Int)
type Pos = WriterT [Cmd] (State Coord)

findPath :: [[Int]] -> [Cmd]
findPath = execPos . toCmds . OrderLanes.fromLists

toCmds :: [[[[(Int,Int)]]]] -> Pos ()
toCmds layers = forM_ (zip layers $ map dir [0..]) $ \(l,d) -> layer d l >> moveUp

layer :: Dir -> [[[(Int,Int)]]] -> Pos ()
layer = mapM_ . lane

lane :: Dir -> [[(Int,Int)]] -> Pos ()
lane = mapM_ . chord

chord :: Dir -> [(Int,Int)] -> Pos ()
chord _ [] = return ()
chord d [x] = moveBefore d x >> on >> moveAfter d x >> off
chord d xs = moveBefore d (head xs) >> on >> moveAfter d (last xs) >> off

realPos :: (Int,Int) -> (Int,Int)
realPos (x,y) = (x*2+1,y*2+1)

moveBefore, moveAfter :: Dir -> (Int,Int) -> Pos ()
moveBefore H pos = do
    (cx,_) <- getPos
    let (tx,ty) = realPos pos
    if cx < tx
        then goto (tx-1,ty)
        else goto (tx+1,ty)

moveBefore V pos = do
    (_,cy) <- getPos
    let (tx,ty) = realPos pos
    if cy < ty
        then goto (tx,ty-1)
        else goto (tx,ty+1)

moveAfter H pos = do
    (cx,_) <- getPos
    let (tx,ty) = realPos pos
    if cx < tx
        then goto (tx+1,ty)
        else goto (tx-1,ty)

moveAfter V pos = do
    (_,cy) <- getPos
    let (tx,ty) = realPos pos
    if cy < ty
        then goto (tx,ty+1)
        else goto (tx,ty-1)

translate :: (Int -> a) -> (Int -> a) -> Int -> Maybe a
translate neg pos n | n <  0 = Just $ neg (-n)
                    | n >  0 = Just $ pos n
                    | otherwise = Nothing

goto :: (Int, Int) -> Pos ()
goto (x,y) = do
    (x',y',z) <- lift get
    unless (x==x' && y==y') $ do
        put (x,y,z)
        let dx = translate W E (x-x')
        let dy = translate N S (y-y')
        tell $ maybeToList dx ++ maybeToList dy

getPos :: Pos (Int,Int)
getPos = (\(x,y,_) -> (x,y)) <$> lift get

on, off, moveUp :: Pos ()
on = tell [On]
off = tell [Off]
moveUp = tell [Up] >> lift (modify (\(x,y,z) -> (x,y,z+1)))

execPos :: Pos a -> [Cmd]
execPos = flip evalState (0,0,0) . execWriterT
