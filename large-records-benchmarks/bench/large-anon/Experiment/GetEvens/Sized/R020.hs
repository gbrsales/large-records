#if PROFILE_CORESIZE
{-# OPTIONS_GHC -ddump-to-file -ddump-ds-preopt -ddump-ds -ddump-simpl #-}
#endif
#if PROFILE_TIMING
{-# OPTIONS_GHC -ddump-to-file -ddump-timings #-}
#endif

{-# LANGUAGE OverloadedLabels #-}

{-# OPTIONS_GHC -fplugin=Data.Record.Anon.Plugin #-}

module Experiment.GetEvens.Sized.R020 where

import Data.Record.Anon.Simple (Record)
import qualified Data.Record.Anon.Simple as Anon

import Bench.EvensOfSize.Evens020
import Common.RowOfSize.Row020

getEvens :: Record ExampleRow -> Evens
getEvens r = Evens {
      -- 00 .. 09
      evens00 = Anon.get #t00 r
    , evens02 = Anon.get #t02 r
    , evens04 = Anon.get #t04 r
    , evens06 = Anon.get #t06 r
    , evens08 = Anon.get #t08 r
      -- 10 .. 19
    , evens10 = Anon.get #t10 r
    , evens12 = Anon.get #t12 r
    , evens14 = Anon.get #t14 r
    , evens16 = Anon.get #t16 r
    , evens18 = Anon.get #t18 r
    }

