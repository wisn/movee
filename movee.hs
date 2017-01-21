{-
    Movee
    Looking up a movie for you
-}

{-# LANGUAGE DeriveGeneric
  , OverloadedStrings
  , FlexibleContexts
  , RecordWildCards #-}

import Data.Aeson (decode, FromJSON, parseJSON, withObject, (.:))
import GHC.Generics (Generic)
import Network.HTTP.Conduit (simpleHttp)
import System.Environment (getArgs)
import Text.Read (readMaybe)
import qualified Data.ByteString.Lazy as BL (ByteString)

-- [DATA]
data Movie = Movie {
  title      :: String
, year       :: String
, genre      :: String
, plot       :: String
, imdbRating :: String
} deriving (Generic, Show)

instance FromJSON Movie where
  parseJSON = withObject "movie" $ \mov -> do
    title      <- mov .: "Title"
    year       <- mov .: "Year"
    genre      <- mov .: "Genre"
    plot       <- mov .: "Plot"
    imdbRating <- mov .: "imdbRating"
    return Movie{..}

-- [MODULES]
getInputMovie :: [String] -> (String, Int)
getInputMovie fromUser =
  let len = length fromUser
  in if len == 1
    then (head fromUser, 0)
    else do
      let year = readMaybe (last fromUser) :: Maybe Int
      case year of
        Nothing -> (unwords fromUser, 0)
        Just y  ->
          ((unwords . init) fromUser, y)

display :: [String] -> IO ()
display message = (putStr . unlines) message

beGreen :: String -> String
beGreen text = "\x1b[32m" ++ text ++ "\x1b[0m"

beRed :: String -> String
beRed text = "\x1b[31m" ++ text ++ "\x1b[0m"

getMovieData :: Movie -> [String]
getMovieData (Movie { title      = t
                    , year       = y
                    , genre      = g
                    , plot       = p
                    , imdbRating = i}) = [t, y, g, p, i]

isItWorthMsg :: Int -> Float -> String
isItWorthMsg year rating =
  let message =
        if year < 2005
          then if rating < 7.0
            then (beRed "This movie seems didn't worth for us...")
            else (beRed "Well, the graphic is old but seems fine for us...")
        else if rating < 7.0
          then (beRed "Well, this movie quite modern but has bad rating...")
          else (beGreen "This movie is awesome! Looks like worth for us!")
  in message

-- [MESSAGES]
help :: [String]
help = [ "Usage: movee NAME [YEAR]" ]



-- [MAIN]
main :: IO ()
main = do
  args <- getArgs
  if (null args)
    then display help
    else do
      let params  = getInputMovie args
          title   = fst params
          year    = snd params
          jsonURL =  "http://www.omdbapi.com/?t="
                  ++ title
                  ++ "&plot=short&r=json"
                  ++ (if year > 0 then "&y=" ++ (show year) else [])

      json <- simpleHttp jsonURL

      let movie = decode json :: Maybe Movie

      case movie of
        Nothing -> do
          display [beRed "It seems the movie didn't exist..."]
          display ["", "Don't forget to check your internet connection!"]
        Just mov -> do
          let mv     = getMovieData mov
              title  = mv !! 0
              y      = readMaybe (mv !! 1) :: Maybe Int
              genre  = mv !! 2
              plot   = mv !! 3
              r      = readMaybe (mv !! 4) :: Maybe Float

              year = case y of
                Nothing  -> 0
                Just num -> num
              rating = case r of
                Nothing  -> 0
                Just num -> num

          display [ "Title  : " ++ title
                  , "Year   : " ++ (show year)
                  , "Genre  : " ++ genre
                  , "Rating : " ++ (show rating)
                  , ""
                  , plot ]

          display ["", isItWorthMsg year rating]
