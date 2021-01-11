module Memebot.Exports 
( module Control.Arrow 
, module Control.Monad
, module Control.Applicative
, module Control.Monad.Trans.Reader
, module Control.Monad.IO.Class
, module Control.Lens
, camelCase
, unCamel
, (?)
, cond
, (|>)

) where 
    
import Data.List.Split
import Control.Arrow
import Data.Char
import Control.Applicative
import Control.Monad.Trans.Reader
import Control.Monad.IO.Class
import Control.Monad
import Control.Lens hiding ((|>))
import Control.Category (Category)

camelCase :: [Char] -> [Char]
camelCase = map toLower |> splitOn "_" |> ht id capitalize |> concat
    where ht f g = liftA2 (:) (f . head) (g . tail)
          capitalize = map (ht toUpper id)
          
unCamel :: [Char] -> [Char]
unCamel = concatMap (cond isUpper (('_' :) . pure . toLower) pure)
   -- ugly, but it's a throwaway func  
    
infixr 1 ?
(?) :: (a -> Bool) -> b -> b -> a -> b
(?) f b1 b2 = cond f (const b1) (const b2)-- if f a then b1 else b2

infixr 1 |>
(|>) :: forall (cat :: k -> k -> *) (a :: k) (b :: k) (c :: k).
        Category cat => cat a b -> cat b c -> cat a c
(|>) = (>>>)

infixr 1 `cond`
cond :: (a -> Bool) -> (a -> b) -> (a -> b) -> a -> b
cond f b1 b2 a = (if f a then b1 else b2) a