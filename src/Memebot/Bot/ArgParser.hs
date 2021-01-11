module Memebot.Bot.ArgParser where

import Memebot.Imgflip.Types
import Data.Attoparsec.Text as A
import Memebot.Exports (many)
import qualified Data.Text as T

-- putting this in a separate module to avoid namespace conflict
parseArgs :: Parser [TextBox]
parseArgs = do 
    let sep c = not (c == ';' || c == '}')
    char '{'
    boxes <- map TB <$> (skipSpace >> A.takeWhile sep) `sepBy` char ';'
    char '}' 
    pure boxes

parseName :: Parser Name
parseName = char '{' >> (T.pack <$> many anyChar) >>= \s -> char '}' >> pure s