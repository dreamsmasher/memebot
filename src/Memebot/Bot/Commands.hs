module Memebot.Bot.Commands where

import Memebot.Exports
import Memebot.Imgflip.Types
import Memebot.Imgflip.Imgflip
import Memebot.Bot.ArgParser
import Discord
import Discord.Types
import Discord.Requests as R
import Data.Maybe
import Data.Text (Text)
import qualified Data.Text as T

eventHandler :: Env -> DiscordHandle -> Event -> DiscordHandler ()
eventHandler env dh ev = case ev of
   MessageCreate m -> unless (fromBot m) $ do
       res <- liftIO (runReaderT (handleMsg m) env')
       case res of Nothing -> pure ()
                   Just url -> do
                       restCall (CreateMessage (messageChannel m) (getUrl url))
                       pure ()
   _ -> pure ()
   
   where env' = env & dsHndl ?~ dh
    
-- so we don't throw an error if there's nothing following the cmd 
safeTail :: Text -> Text
safeTail = \case "" -> ""
                 xs -> T.tail xs 

tryMeme :: Text -> ImgEnv (Maybe Url')
tryMeme = parseMeme |> maybe (pure Nothing) ((map text <$>) |> uncurry buildMeme)

fromBot :: Message -> Bool
fromBot = messageAuthor |> userIsBot

handleMsg :: Message -> ImgEnv (Maybe Url')
handleMsg m = do
    -- TODO separate this into another function to trampoline back down into DiscordHandler 
    case (getArg . messageText) m of
        Nothing -> pure Nothing
        Just arg -> do
            let body = m & (messageText |> T.dropWhile (/= ' ') |> safeTail)
            ds <- fromJust <$> asks (view dsHndl)
            case arg of
                "$meme" -> tryMeme body 
                    