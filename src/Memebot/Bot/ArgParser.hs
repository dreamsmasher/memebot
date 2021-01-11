module Memebot.Bot.ArgParser 
( validArg
, commands
, parseArgs
, parseName
, parseMeme
, parseMemeCmd
, getArg
)
where

import Memebot.Imgflip.Types
import Data.Attoparsec.Text as A
import Memebot.Exports 
import Data.Text (Text)
import qualified Data.Text as T
import Data.HashMap.Strict (HashMap)
import qualified Data.HashMap.Strict as M
import Data.HashSet (HashSet)
import qualified Data.HashSet as S

prefix :: Text 
prefix = "$"

commands :: HashSet Text
commands = S.fromList [ "$meme"
                      , "$preview"
                      , "$list"
                      , "$list2"
                      , "$lookup"
                      , "$help"
                      , "$remindme"
                      , "$asm"
                      , "$about"
                      ]

-- to avoid crashing when the msg is empty
validArg :: Text -> Bool
validArg = T.splitAt 1 
         |> (== prefix) *** (T.takeWhile (/= ' ') 
            |> (`S.member` commands)) 
         |> uncurry (&&)

getArg :: Text -> Maybe Text
getArg s = if S.member pfx commands then Just pfx else Nothing
    where pfx = T.takeWhile (/= ' ') s
-- putting this in a separate module to avoid namespace conflict

inBraces :: Parser a -> Parser a 
inBraces p = char '{' >> p >>= \s -> char '}' >> pure s

parseArgs :: Parser [TextBox]
parseArgs = do 
    let sep c = not (c == ';' || c == '}')
    inBraces (map TB <$> (skipSpace >> A.takeWhile sep) `sepBy` char ';')

parseName :: Parser Name
parseName = inBraces (A.takeWhile (/= '}'))

parseMemeCmd :: Parser (Name, [TextBox])
parseMemeCmd = do
    skipSpace
    name <- parseName
    skipSpace
    body <- parseArgs
    pure (name, body)

parseMeme :: Text -> Maybe (Name, [TextBox])
parseMeme = parse parseMemeCmd >>> maybeResult 
-- TODO maybe we should put the command parsing logic in here too?
