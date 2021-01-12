module Memebot.Bot.Commands where

import Memebot.Exports
import Memebot.Imgflip.Types
import Memebot.Imgflip.Imgflip
import Memebot.Bot.ArgParser
import Memebot.Bot.Types
import Discord
import Discord.Types
import Discord.Requests as R
import Data.Maybe
import Data.Text (Text)
import qualified Data.Text as T

type HandlerRes = Maybe Text
eventHandler :: Env -> Event -> DiscordHandler ()
eventHandler env ev = case ev of
   MessageCreate m -> unless (fromBot m) $ do
       dh <- ask
       let env' = env & dsHndl ?~ dh
       handlerRes <- liftIO (runReaderT (handleMsg m) env')
       case handlerRes of 
           Nothing -> pure ()
           Just res -> do
               restCall (CreateMessage (messageChannel m) res)
               pure ()
   _ -> pure ()
   
--    where env' = env & dsHndl ?~ dh
    
-- so we don't throw an error if there's nothing following the cmd 
safeTail :: Text -> Text
safeTail = \case "" -> ""
                 xs -> T.tail xs 

tryMeme :: BotInv -> ImgEnv (Maybe Url')
tryMeme = parseMeme |> maybe (pure Nothing) ((map text <$>) |> uncurry buildMeme)

fromBot :: Message -> Bool
fromBot = messageAuthor |> userIsBot

handleMsg :: Message -> ImgEnv HandlerRes
handleMsg m = do
    -- TODO separate this into another function to trampoline back down into DiscordHandler 
    case (getArg . messageText) m of
        Nothing -> pure Nothing
        Just arg -> do
            let body = m & (messageText |> T.dropWhile (/= ' ') |> safeTail)
            ds <- fromJust <$> asks (view dsHndl)
            case arg of
                "$meme" -> tryMeme body <&> fmap getUrl
                    
-- validArgs :: Parser Text                
-- validArgs = 