{-# LANGUAGE TemplateHaskell #-}
module Effects where

-- import Calamity.Types
import Polysemy
import Control.Monad
import Control.Applicative
import Control.Arrow
import Data.Text as T

newtype Url = Url Text
newtype ImgId = ImgId Text

data Memes m a where
    MakeMeme :: ImgId -> [Text] -> Memes m Url
    
data MemeBot m a where
    SendMeme :: 
    
-- makeMeme :: Member (Embed IO) r => ImgId -> [Text] -> Sem r Url
-- makeMeme id args = send (MakeMeme id args :: Memes (Sem r) ImgId) 

makeSem '' Memes