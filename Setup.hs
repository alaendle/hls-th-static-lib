import Distribution.Simple
import qualified Distribution.PackageDescription as PD
import Distribution.Simple.LocalBuildInfo
import Distribution.Simple.Setup
import Distribution.Simple.Utils
import System.Directory
import Data.Maybe

main = defaultMainWithHooks simpleUserHooks { confHook = gatewayConfHook }

gatewayConfHook :: (PD.GenericPackageDescription, PD.HookedBuildInfo) ->
                  ConfigFlags ->
                  IO LocalBuildInfo
gatewayConfHook (description, buildInfo) flags = do
    localBuildInfo <- confHook simpleUserHooks (description, buildInfo) flags
    let packageDescription = localPkgDescr localBuildInfo
        library = fromJust $ PD.library packageDescription
        libraryBuildInfo = PD.libBuildInfo library
        libPref = libdir $ absoluteInstallDirs packageDescription localBuildInfo NoCopyDest
    dir <- getCurrentDirectory
    print $ "Extend library search path to: " ++ libPref -- only for debugging
    pure localBuildInfo {
        localPkgDescr = packageDescription {
            PD.library = Just $ library {
                PD.libBuildInfo = libraryBuildInfo {
                    PD.extraLibDirs = libPref : (dir ++ "/lib") :PD.extraLibDirs libraryBuildInfo
                }
            }
        }
    }