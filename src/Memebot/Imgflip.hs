{-# LANGUAGE OverloadedStrings #-}
module Memebot.Imgflip 
( populateMemes
, getMemes
, getMeme
, getMemeId
, postMeme
, mkMeme

)
where

import Data.Aeson
import Network.HTTP.Req
import Control.Monad.IO.Class
import Control.Monad.Trans.Reader
import Data.HashMap.Strict (HashMap)
import qualified Data.HashMap.Strict as M

import Memebot.Exports
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
mkMeme :: Name -> [Text] -> ImgEnv (Maybe Url')
mkMeme name body = do
    imgId <- getMemeId name
    case imgId of
        Nothing -> pure Nothing
        Just i -> do
            body <- imgCap i body
            request $ do
                val <- responseBody <$> postMeme body
                liftIO $ print val
                let res = fromCapResp val
                liftIO $ print res
                pure $ res <&> (Url' . urlR)
            
populateMemes :: IO (HashMap Name MemeData)
populateMemes = request 
    getMemes >>= (responseBody |> map ((view name |> T.toLower) >>= (,)) |> M.fromList |> pure)
    
getMeme :: Name -> ImgEnv (Maybe MemeData)
getMeme n = asks (M.lookup n . view memes)

getMemeId :: Name -> ImgEnv (Maybe ImgId)
getMemeId = getMeme >=> fmap (ImgId . view memeId) |> pure

request :: MonadIO m => Req a -> m a
request = runReq defaultHttpConfig 
    