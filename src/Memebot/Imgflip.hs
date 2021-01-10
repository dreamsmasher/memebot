{-# LANGUAGE OverloadedStrings #-}
module Memebot.Imgflip where

import Data.Aeson
import Network.HTTP.Req
import Control.Monad
import Control.Applicative
import Control.Arrow
import Control.Monad.Reader.Class
import Control.Monad.IO.Class

import Data.Text (Text)
import qualified Data.Text as T

-- mkEndPt :: Text -> Url
mkEndpt :: Text -> Url 'Https
mkEndpt = (https "api.imgflip.com" /:)

-- | get the top 100 memes from ImgFlip
getMemes :: (MonadHttp m) => m (JsonResponse Text)
getMemes = req POST url NoReqBody jsonResponse mempty 
    where url = mkEndpt "get_memes"
    
