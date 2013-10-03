module Main where

import qualified PivotalStats as P
import qualified System.Environment as E
import qualified Data.Maybe as MB
import qualified Control.Monad as M
import qualified System.Environment as S

main :: IO ()
main = do
  token <- E.getEnv "TRACKER_TOKEN"
  args <- S.getArgs
  stories <- P.stories token (read (head args) :: Int)

  case stories of
    Nothing -> putStrLn "Unable to retrieve stories"
    Just st -> print (P.storyTypes st)
