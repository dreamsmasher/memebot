module Main where
import qualified Data.Text.Lazy as T
import Web.Scotty.Trans
import System.Environment
import Calamity
import Data.Aeson
import Polysemy

main :: IO ()
main = do
    isDev <- lookupEnv "DEV"
    [_token, permissions] <- mapM getEnv ["DISCORD_TOKEN", "DISCORD_PERMS"]
    -- let token = BotToken (T.pack _token)
    putStrLn "hi"
    -- runBotIO token defaultIntents 
    
-- parseConfigFile :: IO (String, String)
-- parseConfigFile = do
--     s <- readFile 