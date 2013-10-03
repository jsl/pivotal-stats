{-# LANGUAGE DeriveGeneric, OverloadedStrings #-}

module PivotalStats (stories, storyTypes) where

import qualified GHC.Generics as G
import qualified Network.HTTP.Conduit as C
import qualified Data.Aeson as D
import qualified Data.Text.Encoding as TE
import qualified Data.Text as T

apiUrl = "https://www.pivotaltracker.com/services/v5"

data Story =
    Story {
      story_type :: String
    } deriving (Show, G.Generic, Eq)

instance D.FromJSON Story

storiesUrl :: Int -> String
storiesUrl projectId = apiUrl ++ "/projects/" ++ show projectId ++ "/stories"

data StoryCounts =
    StoryCounts {
        chores   :: Int
      , features :: Int
      , bugs     :: Int
    } deriving (Show, Eq)

sumStoryCounts :: [Story] -> StoryCounts -> StoryCounts
sumStoryCounts [] storyCounts = storyCounts
sumStoryCounts (x:xs) storyCounts
    | story_type x == "feature" = sumStoryCounts xs storyCounts
                                  { features = features storyCounts + 1 }
    | story_type x == "bug"     = sumStoryCounts xs storyCounts
                                  { bugs = bugs storyCounts + 1 }
    | story_type x == "chore"   = sumStoryCounts xs storyCounts
                                  { chores = chores storyCounts + 1 }
    | otherwise                 = sumStoryCounts xs storyCounts

storyTypes :: [Story] -> StoryCounts
storyTypes stories = sumStoryCounts
                     stories
                     StoryCounts { chores = 0, features = 0, bugs = 0  }

stories :: String -> Int -> IO (Maybe [Story])
stories token projectId = do
  req <- C.parseUrl $ storiesUrl projectId

  let req' = req { C.requestHeaders =
                       [("X-TrackerToken", (TE.encodeUtf8 . T.pack) token)]}

  res <- C.withManager $ \m -> C.httpLbs req' m

  return $ D.decode $ C.responseBody res
