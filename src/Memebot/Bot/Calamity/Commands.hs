module Memebot.Bot.Calamity.Commands where

import Data.ByteString (ByteString)
import qualified Data.ByteString as B
import Data.Text (Text)
import qualified Data.Text as T
import Calamity.Commands.Dsl
import Calamity.Commands.Parser
import Calamity.Commands.Command
import Calamity.Commands.CommandUtils
import Calamity
import Polysemy (Sem)
import qualified Polysemy as P
import Memebot.Exports
import Memebot.Bot.Calamity.Types
import Memebot.Imgflip.Types
import Memebot.Bot.ArgParser (parseArgs)
    
newtype MemeParser r a = MP {runMemeParse :: Text -> Either String [TextBox]}

-- memeCmd :: Member (Embed IO) r => Sem (Memes ': r) a -> Sem r a
-- memeCmd = command @'[Named "args" (KleeneStarConcat Text)] "meme" $ \ctx t -> do
--         pure undefined

--     where helpStr = "Takes in a meme name, and text fields. Commands are given in the format {meme name} {expr1; expr2;...}"