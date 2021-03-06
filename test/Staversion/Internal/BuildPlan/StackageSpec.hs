module Staversion.Internal.BuildPlan.StackageSpec (main,spec) where

import Control.Applicative ((<$>), (<*>), pure)
import qualified Data.ByteString as BS
import qualified Data.ByteString.Lazy as BSL
import System.FilePath ((</>), (<.>))
import Test.Hspec
import Test.QuickCheck (Arbitrary(..), oneof, property, Gen)

import Staversion.Internal.BuildPlan.Stackage
  ( parseResolverString, formatResolverString,
    PartialResolver(..), ExactResolver(..),
    Disambiguator, parseDisambiguator
  )

instance Arbitrary ExactResolver where
  arbitrary = oneof [ ExactLTS <$> arbitrary <*> arbitrary,
                      ExactNightly <$> arbitrary <*> arbitrary <*> arbitrary
                    ]

instance Arbitrary PartialResolver where
  arbitrary = oneof [ PartialExact <$> arbitrary,
                      pure PartialLTSLatest,
                      PartialLTSMajor <$> arbitrary,
                      pure PartialNightlyLatest
                    ]

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  parse_spec
  format_spec
  parseDis_spec

parse_spec :: Spec
parse_spec = describe "parseResolverString" $ do
  ex "lts-7.0" (Just $ PartialExact $ ExactLTS 7 0)
  ex "lts-2.22" (Just $ PartialExact $ ExactLTS 2 22)
  ex "lts-4" (Just $ PartialLTSMajor 4)
  ex "lts" (Just $ PartialLTSLatest)
  ex "nightly-2016-10-21" (Just $ PartialExact $ ExactNightly 2016 10 21)
  ex "nightly" (Just $ PartialNightlyLatest)
  ex "hoge" Nothing
  ex "lts-5." (Just $ PartialLTSMajor 5)
  ex "lts-" Nothing
  ex "nightly-2016" Nothing
  ex "nightly-2016-10-" Nothing
  where
    ex input expected = specify input $ parseResolverString input `shouldBe` expected

format_spec :: Spec
format_spec = describe "formatResolverString" $ do
  it "should generate parsable string" $ property $ \presolver ->
    (parseResolverString $ formatResolverString presolver) == Just presolver
  it "should pad nightly month/day with 0" $ do
    formatResolverString (PartialExact $ ExactNightly 2010 1 8) `shouldBe` "nightly-2010-01-08"

parseDis_spec :: Spec
parseDis_spec = describe "parseDisambiguator" $ do
  describe "snapshots.json" $ before (loadDisambiguator "snapshots.json") $ do
    it "disambiguates exact resolvers" $ \dis -> property $ \p_exact -> do
      dis (PartialExact p_exact) == Just p_exact
    it "disambiguates lts-2" $ \dis -> do
      dis (PartialLTSMajor 2) `shouldBe` Just (ExactLTS 2 22)
    it "disambiguates lts" $ \dis -> do
      dis (PartialLTSLatest) `shouldBe` Just (ExactLTS 7 5)
    it "disambiguates nightly" $ \dis -> do
      dis (PartialNightlyLatest) `shouldBe` Just (ExactNightly 2016 10 22)
    it "cannot disambiguate lts future version" $ \dis -> do
      dis (PartialLTSMajor 999) `shouldBe` Nothing
    

loadDisambiguator :: FilePath -> IO Disambiguator
loadDisambiguator file_name = expectJust =<< (parseDisambiguator <$> BSL.fromStrict <$> BS.readFile file_path) where
  file_path = "test" </> "data" </> file_name
  expectJust Nothing = error "parse should succeed"
  expectJust (Just d) = return d
