{-# LANGUAGE CPP             #-}
{-# LANGUAGE TemplateHaskell #-}

#if USE_GHC_DUMP
{-# OPTIONS_GHC -fplugin=GhcDump.Plugin #-}
#endif

module Test.Record.Generic.Size.After.R1000 where

import Data.Aeson (ToJSON(..))

import Data.Record.Generic
import Data.Record.Generic.JSON
import Data.Record.Generic.TH

import Test.Record.Generic.Size.Infra

largeRecord defaultOptions (recordOfSize 1000)

instance ToJSON R where
  toJSON = gtoJSON
