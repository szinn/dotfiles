-- Rex configuration

-- >>> resh >>>
dofile("/Users/scotte/Library/Application Support/resh/resh.lua")
rex.exec.start({ "/Users/scotte/Library/Application Support/resh/resh", "service", "start" },
  { detach = true, stdout = false, stderr = false })
-- <<< resh <<<
