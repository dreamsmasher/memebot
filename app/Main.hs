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
import Memebot.Bot.Commands
import Memebot.Exports
import Data.Default
import Discord

mkEnv :: IO RunDiscordOpts
mkEnv = do
    memes <- populateMemes
    [usr, pass, dsc] <- map T.pack <$> mapM getEnv 
        ["IMGFLIP_USERNAME", "IMGFLIP_PASSWORD", "DISCORD_TOKEN"]
    let defOpts = def :: RunDiscordOpts
    let env = Env memes (UN usr, PW pass) Nothing
    pure $ defOpts { discordToken = dsc
                   , discordOnLog = IOT.putStrLn
                   , discordOnStart = liftIO (putStrLn "listening")
                   , discordOnEvent = eventHandler env
                   }
main :: IO ()
main = do
    isDev <- lookupEnv "DEV"
    mkEnv >>= runDiscord >> pure ()   