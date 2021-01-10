{-# LANGUAGE TemplateHaskell, DeriveGeneric, OverloadedStrings #-}
module Memebot.Types 
( Url
, ImgId
, MemeData (..)
, Memes (..)
) where

-- This module exports our TemplateHaskell-derived lenses, classes, and instances
-- import Calamity.Types
import Polysemy
import Data.Text (Text)
import qualified Data.Text as T
import Data.Char
import Data.List.Split (splitOn)
import Data.Aeson.TH
import Data.Aeson (encode, decode)

import Memebot.Exports
import Control.Lens.TH

newtype Url = Url Text
newtype ImgId = ImgId Text

data MemeData = MD {
    _id :: Int,
    _name :: Text,
    _url :: Text,
    _width :: Int,
    _height :: Int,
    _boxCount :: Int
} deriving (Eq, Show)


deriveJSON defaultOptions
    { constructorTagModifier = ('_' :) . camelCase
    , fieldLabelModifier = unCamel . drop 1 
    } ''MemeData 

makeLenses ''MemeData

data Memes m a where
    MakeMeme :: ImgId -> [Text] -> Memes m Url

makeSem '' Memes
