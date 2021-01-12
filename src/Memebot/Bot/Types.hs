module Memebot.Bot.Types (BotCmd (..), BotInv (..)) where

import Memebot.Exports
import Memebot.Imgflip.Types
import Data.Text (Text)
import qualified Data.Text as T
import Text.ParserCombinators.ReadPrec

data BotCmd = Meme | Preview | Help | Remind | List1 | List2 | Lookup deriving (Eq, Show, Read, Enum)

data BotInv = BotInv { command :: BotCmd
                     , arg1 :: Maybe Name
                     , arg2 :: Maybe [TextBox] -- I'm out of field name ideas
                     } deriving Show