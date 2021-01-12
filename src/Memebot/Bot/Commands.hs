module Memebot.Bot.Commands where

import Control.Concurrent
import Control.Concurrent.Async
import Control.Monad.Extra
import Data.Maybe
import Data.Text (Text)
import qualified Data.Text as T
import Discord
import Discord.Requests as R
import Discord.Types
import Memebot.Bot.ArgParser
import Memebot.Bot.Types
import Memebot.Exports
import Memebot.Imgflip.Imgflip
import Memebot.Imgflip.Types
import Text.Read (readMaybe)

-- turns out this is already a function
-- if it's useful, it's probably in the standard libraries
-- something something maybeT

type HandlerRes = Maybe Text

eventHandler :: Env -> Event -> DiscordHandler ()
eventHandler env ev = case ev of
  MessageCreate m -> unless (fromBot m) $ do
    dh <- ask
    let env' = env & dsHndl ?~ dh
    res <- liftIO (runReaderT (handleMsg m) env')
    liftIO (print res)
    whenJust res $ \body -> do
      restCall (CreateMessage (messageChannel m) body)
      pure ()
  _ -> pure ()

tryMeme :: BotInv -> ImgEnv (Maybe Url')
tryMeme = \case
  BotInv _ (Just name) args -> buildMeme name $ args & (fromMaybe [] |> map text)
  _ -> pure Nothing

fromBot :: Message -> Bool
fromBot = messageAuthor |> userIsBot

handleMsg :: Message -> ImgEnv HandlerRes
handleMsg m = do
  -- TODO separate this into another function to trampoline back down into DiscordHandler
  case parse (messageText m) of
    Nothing -> pure Nothing
    Just b@(BotInv cmd a1 a2) -> do
      ds <- fromJust <$> asks (view dsHndl)
      liftIO (print b)
      case cmd of
        Meme -> tryMeme b <&> fmap getUrl
        Preview -> tryMeme (b {arg2 = Just []}) <&> fmap getUrl
        -- this is backwards TODO make it actually search
        Lookup -> a1 & maybe (pure Nothing) (\name -> getMeme name <&> fmap (view url))
        List1 -> showMemes False
        List2 -> showMemes True
        _ -> pure $ Just "invalid command, you donkey"

setTimeout :: Int -> IO a -> IO a
setTimeout n f = async (threadDelay (n * 1000000)) >> f

-- reminder is a special case because we need to lower it down back into the Discord monad
-- TODO: rewrite the library to add a DiscordT type
reminder :: BotInv -> ImgEnv (Maybe (Int, Text))
reminder = \case
  BotInv _ (Just time) (Just args) -> liftIO $ do
    let n = readMaybe (T.unpack time) :: Maybe Int
        t = T.concat $ map text args -- can't use concatMap here
    pure $ case (n, t) of
      (_, "") -> Nothing
      (Just n', t') -> Just (n', t')
      _ -> Nothing
  _ -> pure Nothing

-- validArgs :: Parser Text
-- validArgs =