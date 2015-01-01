module Main(main) where

import System.Hardware.Serialport
import Control.Monad
import System.Environment (getArgs)
import System.IO

communicate :: Handle -> String -> IO ()
communicate h "-i" = (.) forever interactive h
communicate h msg = do
    hPutStr h msg
    putStrLn $ "> " ++ msg
    response <- hGetLine h
    putStrLn $ "< " ++ response


interactive :: Handle -> IO ()
interactive h = do
    msg <- getLine
    hPutStrLn h msg
    response <- hGetLine h
    putStrLn $ "< " ++ response

main :: IO ()
main = do
    (device:cmds) <- getArgs
    port <- hOpenSerial device $ defaultSerialSettings { timeout = 200 }
    forM_ cmds $ communicate port
    hClose port
