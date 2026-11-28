-- Rex configuration

-- >>> resh >>>
do
  local result = rex.exec({ "/opt/homebrew/opt/resh/libexec/resh", "print-rex-startup-lua" }, { timeout = 5 })
  if result and result.ok then
    local startup, err = loadstring(result.stdout, "@resh startup")
    if startup then startup() else rex.log("warn", err) end
  end
end
-- <<< resh <<<
