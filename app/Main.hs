{-# LANGUAGE OverloadedStrings #-}
module Main where
import qualified Data.Text as T
import qualified Data.Text.IO as IOT 
import Web.Scotty.Trans
import System.Environment
import Calamity
import Data.Aeson
import Memebot.Imgflip.Types
import Memebot.Imgflip.Imgflip
import Memebot.Exports
import Data.Default
import Discord

mkEnv :: IO Env
mkEnv = do
    memes <- populateMemes
    [usr, pass, dsc] <- map T.pack <$> mapM getEnv 
        ["IMGFLIP_USERNAME", "IMGFLIP_PASSWORD", "DISCORD_TOKEN"]
    let defOpts = def :: RunDiscordOpts
    let opts = defOpts { discordToken = dsc
                       , discordOnLog = IOT.putStrLn
                       }
    pure $ Env memes (UN usr, PW pass) opts Nothing

main :: IO ()
main = do
    isDev <- lookupEnv "DEV"
    env <- mkEnv
    flip runReaderT env $ do
        discordOpts <- asks (view dsOpts)

    pure ()
        
    -- [_token, permissions] <- mapM getEnv ["DISCORD_TOKEN", "DISCORD_PERMS"]
    -- let token = BotToken (T.pack _token)
    -- putStrLn "hi"