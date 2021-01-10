{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_memebot (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/normie/Projects/memebot/.stack-work/install/x86_64-linux-tinfo6/0e969d58c5161964e376208831584847d71ad546a59d3a4819625eef6ece2202/8.8.4/bin"
libdir     = "/home/normie/Projects/memebot/.stack-work/install/x86_64-linux-tinfo6/0e969d58c5161964e376208831584847d71ad546a59d3a4819625eef6ece2202/8.8.4/lib/x86_64-linux-ghc-8.8.4/memebot-0.1.0.0-FXevElXrdqQFCrhglGQWrM-memebot-exe"
dynlibdir  = "/home/normie/Projects/memebot/.stack-work/install/x86_64-linux-tinfo6/0e969d58c5161964e376208831584847d71ad546a59d3a4819625eef6ece2202/8.8.4/lib/x86_64-linux-ghc-8.8.4"
datadir    = "/home/normie/Projects/memebot/.stack-work/install/x86_64-linux-tinfo6/0e969d58c5161964e376208831584847d71ad546a59d3a4819625eef6ece2202/8.8.4/share/x86_64-linux-ghc-8.8.4/memebot-0.1.0.0"
libexecdir = "/home/normie/Projects/memebot/.stack-work/install/x86_64-linux-tinfo6/0e969d58c5161964e376208831584847d71ad546a59d3a4819625eef6ece2202/8.8.4/libexec/x86_64-linux-ghc-8.8.4/memebot-0.1.0.0"
sysconfdir = "/home/normie/Projects/memebot/.stack-work/install/x86_64-linux-tinfo6/0e969d58c5161964e376208831584847d71ad546a59d3a4819625eef6ece2202/8.8.4/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "memebot_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "memebot_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "memebot_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "memebot_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "memebot_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "memebot_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
