{-# LANGUAGE OverloadedStrings #-}
module Memebot.Imgflip.Imgflip
( populateMemes
, getMemes
, getMeme
, getMemeId
, postMeme
, mkMeme
, buildMeme
)
where

import Data.Aeson
import Network.HTTP.Req
import Control.Monad.IO.Class
import Control.Monad.Trans.Reader
import Data.HashMap.Strict (HashMap)
import qualified Data.HashMap.Strict as M

import Memebot.Exports
import Memebot.Imgflip.Types
import Memebot.Types

import Data.Text (Text)
import qualified Data.Text as T


-- mkEndPt :: Text -> Url
mkEndpt :: Text -> Url 'Https
mkEndpt = (https "api.imgflip.com" /~)

-- | get the top 100 memes from ImgFlip
getMemes :: (MonadHttp m) => m (ImgResponse [MemeData])
getMemes = req GET url NoReqBody imgResponse mempty 
    where url = mkEndpt "get_memes"

postMeme :: MonadHttp m => ImgCap -> m (JsonResponse Value)
postMeme c = req POST url (ReqBodyUrlEnc (toQuery c)) jsonResponse mempty
    where url = mkEndpt "caption_image"

-- buildMemeReq :: ImgId -> [Text] ->    
mkMeme :: ImgId -> [Text] -> ImgEnv (Maybe Url')
mkMeme imgId body = do
    body <- imgCap imgId body
    request $ do
        val <- responseBody <$> postMeme body
        pure $ fromCapResp val <&> (Url' . urlR)
            
populateMemes :: IO (HashMap Name MemeData)
populateMemes = request 
    getMemes >>= (responseBody |> map ((view name |> T.toLower) >>= (,)) |> M.fromList |> pure)
    
getMeme :: Name -> ImgEnv (Maybe MemeData)
getMeme n = asks (M.lookup n . view memes)

getMemeId :: Name -> ImgEnv (Maybe ImgId)
getMemeId = getMeme >=> fmap (ImgId . view memeId) |> pure

buildMeme :: Name -> [Text] -> ImgEnv (Maybe Url')
buildMeme n t = getMemeId n >>= maybe (pure Nothing) (`mkMeme` t)

request :: MonadIO m => Req a -> m a
request = runReq defaultHttpConfig 
    