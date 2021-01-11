{-# LANGUAGE TemplateHaskell
           , DeriveGeneric
           , OverloadedStrings
           , FlexibleInstances
           , DeriveFunctor 
           , GeneralizedNewtypeDeriving
           #-}
             
module Memebot.Types where

-- This module exports our TemplateHaskell-derived lenses, classes, and instances
-- import Calamity.Types
import Polysemy
import Data.Text (Text)
import qualified Data.Text as T
import Data.List.Split (splitOn)
import Data.Aeson.TH
import Data.Aeson 
import GHC.Generics (Generic)
import Memebot.Exports
import Control.Lens.TH
import Data.ByteString.Lazy (ByteString)
import qualified Data.ByteString.Lazy.Char8 as C 
import qualified Data.ByteString.Lazy as B
import Data.Aeson.Lens
import qualified Network.HTTP.Client as L
import Network.HTTP.Req
import Control.Exception 
import Data.Proxy
import Data.HashMap.Strict (HashMap)
import qualified Data.HashMap.Strict as M
import Data.String
import Data.Text.Encoding (decodeUtf8)

newtype Url' = Url' Text deriving (Show, Eq)
newtype ImgId = ImgId Text deriving (Show, Eq)
newtype Username = UN Text deriving (Show, Eq)
newtype Password = PW Text deriving (Show, Eq)
newtype Token = TK Text deriving (Show, Eq)

data Env = Env { _memes :: HashMap Name MemeData
               , _ifAcc :: (Username, Password)
               , _token :: Token
               } deriving (Eq, Show)
               
type Name = Text

data MemeData = MD {
    _memeId :: Text, -- why is this a string...
    _name :: Name,
    _url :: Text,
    _width :: Int,
    _height :: Int,
    _boxCount :: Int
} deriving (Eq, Show, Generic)

newtype TextBox = TB { text :: Text } deriving (Eq, Show, IsString)


fromImgflip :: Value -> Result [MemeData]
fromImgflip = (^?! key "data") |> (^?! key "memes") |> fromJSON

fromSuccess :: Result [MemeData] -> [MemeData]
fromSuccess = \case
   Error _ -> [] 
   Success m -> m

-- fromCapResp :: Value -> Maybe (Url', Url')
        
data UrlResp = UR { urlR :: Text
                  , pageUrlR :: Text
                  } deriving (Eq, Show)

newtype ImgResponse a = IR (L.Response a) deriving (Show, Functor)
data ImgCap = ImgCap { template_id :: Text
                     , username :: Text
                     , password :: Text
                     , boxes :: [TextBox]
                     } deriving (Eq, Show)

fromBoxes :: [TextBox] -> Text
fromBoxes = decodeUtf8 . B.toStrict . encode
     
toQuery :: (QueryParam a, Monoid a) => ImgCap -> a
toQuery = foldMap (uncurry (flip queryParam . Just)) . go
    where go (ImgCap t u p b) = zip 
            [t, u, p] 
            ["template_id", "username", "password"] 
            <> (zip b [0..] 
                & map (text 
                *** (\x -> "boxes[" <> (T.pack . show $ x) <> "][text]")))
            -- so so so ugly, why is the imgflip api like this

-- lifted almost verbatim from Network.HTTP.Req
-- ugly hack to allow us to be able to convert an ImgFlip response directly in a response handler
-- might be worth a pull request if I made this generic? 
instance HttpResponse (ImgResponse [MemeData]) where
    type HttpResponseBody (ImgResponse [MemeData]) = [MemeData]
    toVanillaResponse (IR a) = a
    getHttpResponse r = do
        chunks <- L.brConsume (L.responseBody r)
        case eitherDecode (B.fromChunks chunks) of
            Left e -> throwIO (JsonHttpException e)
            Right x -> pure $ fromSuccess . fromImgflip <$> IR (x <$ r)

imgResponse :: Proxy (ImgResponse [MemeData])
imgResponse = Proxy

type ImgEnv = ReaderT Env IO

data Memes m a where
    MakeMeme :: ImgId -> [Text] -> Memes m Url'

makeSem ''Memes

makeLenses ''MemeData

makeLenses ''Env            

deriveJSON defaultOptions
    { constructorTagModifier = cond (== "id") (const "_memeId") ('_' :) . camelCase 
    , fieldLabelModifier = cond (== "_memeId") (const "id") (unCamel . drop 1)
    } ''MemeData 
    -- avoid namespace conflict with "id"

deriveJSON defaultOptions ''TextBox
deriveJSON defaultOptions ''ImgCap
deriveJSON defaultOptions
    { constructorTagModifier = (++ "R") . camelCase
    , fieldLabelModifier = unCamel . init
    } ''UrlResp

imgCap :: ImgId -> [Text] -> ImgEnv ImgCap
imgCap (ImgId i) t = do
    (UN u, PW p) <- asks (view ifAcc)
    pure $ ImgCap i u p (map TB t)


fromCapResp :: Value -> Maybe UrlResp
fromCapResp = (^? key "data") >=> (fromJSON |> \case {Error _ -> Nothing; Success x -> Just x})