module Memebot.Bot.ArgParser 
( parseArgs
, parseName
, parseMessage
)
where

import Memebot.Bot.Types
import Memebot.Imgflip.Types
import Data.Attoparsec.Text as A hiding (parse)
import Memebot.Exports 
import Data.Text (Text)
import qualified Data.Text as T
import Data.HashMap.Strict (HashMap)
import qualified Data.HashMap.Strict as M
import Data.HashSet (HashSet)
import qualified Data.HashSet as S
import Text.Read (readMaybe)
import Data.Char (toUpper)

prefix :: Char 
prefix = '$'

inBraces :: Parser a -> Parser a 
inBraces p = char '{' >> p <* char '}' 

parseArgs :: Parser [TextBox]
parseArgs = do 
    -- let sep c = not (c == ';' || c == '}')
    let sep = not . liftA2 (||) (== ';') (== '}')
    inBraces (map TB <$> (skipSpace >> A.takeWhile sep) `sepBy` char ';')

parseName :: Parser Name
parseName = inBraces (A.takeWhile (/= '}'))

capitalize :: Text -> Text
capitalize = liftA2 T.cons (toUpper . T.head) (T.toLower . T.tail)

parseMessage :: Parser BotInv
parseMessage = do
    cmd <- parseCmd
    end <- atEnd <* skipSpace
    if end then pure (BotInv cmd Nothing Nothing) else do
        args <- optional parseName <* skipSpace
        boxes <- optional parseArgs <* skipSpace
        pure $ BotInv cmd args boxes

parse :: Text -> Maybe BotInv
parse = parseOnly (parseMessage <* endOfInput) |> either (const Nothing) Just 

-- convert every possible string representation of BotCmd into a parser, combining them
-- into a choice parser
parseCmd :: Parser BotCmd
parseCmd = choice $ map (parseBot . T.pack . show) (enumFrom (toEnum 0 :: BotCmd))
    where parseBot s = string ((T.cons prefix . T.toLower) s)
                    <&> read . T.unpack . capitalize . T.tail 