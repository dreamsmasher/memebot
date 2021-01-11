{-# LANGUAGE OverloadedStrings #-}
module Main where
import qualified Data.Text as T
import Web.Scotty.Trans
import System.Environment
import Calamity
import Data.Aeson
import qualified Polysemy as P
import Memebot.Types
import Memebot.Imgflip
import Memebot.Exports

mkEnv :: IO Env
mkEnv = do
    memes <- populateMemes
    [usr, pass] <- map T.pack <$> mapM getEnv ["IMGFLIP_USERNAME", "IMGFLIP_PASSWORD"]
    pure $ Env memes (UN usr, PW pass) (TK "")

main :: IO ()
main = do
    isDev <- lookupEnv "DEV"
    env <- mkEnv
    flip runReaderT env $ do
        res <- mkMeme "doge" ["hello", "test 1", "test2"]
        liftIO $ print res
    pure ()
        
    -- [_token, permissions] <- mapM getEnv ["DISCORD_TOKEN", "DISCORD_PERMS"]
    -- let token = BotToken (T.pack _token)
    -- putStrLn "hi"