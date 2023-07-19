{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Lib
    ( someFunc
    ) where

import qualified Language.C.Inline as C

C.include "<math.h>"

someFunc :: IO ()
someFunc = do
  x <- [C.exp| double{ cos(1) } |]
  print x
