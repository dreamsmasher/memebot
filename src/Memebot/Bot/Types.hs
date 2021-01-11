{-# LANGUAGE TemplateHaskell #-}
module Memebot.Bot.Types where

-- import Calamity
import Polysemy
import Polysemy.Internal
import Polysemy.Reader
import Memebot.Imgflip.Types
import Data.Text 
import qualified Data.Text as T

data Memes m a where
    TryMeme :: Name -> [Text] -> Memes m (Maybe ImgId)
    MakeMeme :: (Name, [Text]) -> Memes m Url'

makeSem ''Memes

data MemebotEnv m a where
    GetEnv :: Env -> MemebotEnv m Env

-- getEnv :: Members '[MemebotEnv, Embed IO] r => Sem r Env
-- getEnv = send 
    