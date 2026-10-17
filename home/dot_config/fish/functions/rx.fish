# rx - open a Rex session, creating it first when it does not exist.
#
# Usage:
#   rx                  session for $PWD (label = basename of $PWD)
#   rx <name>           session from definition <name>.lua, else from the
#                       only definition starting with <name>, else a plain
#                       session labeled <name> at $PWD
#   rx --nw [<name>]    same, but show the session in a new Rex app window
#   rx --export [session]
#                       print a definition based on a Rex session
#   rx -h|--help        print usage
#
# Definitions are Lua files at $XDG_CONFIG_HOME/rex/sessions/<name>.lua
# (~/.config/rex/sessions/ by default); see README.md.
function rx --description 'Open a Rex session, creating it when missing'
    if set -q DEBUG; and test -n "$DEBUG"
        set -l fish_trace 1
    end

    # REX_BIN_DIR puts rex on PATH only inside Rex terminals.
    set -l rex rex
    if not command -q rex
        set rex "/Applications/Rex Beta.app/Contents/Helpers/Rex Server.app/Contents/MacOS/rex"
    end

    set -l usage_text "Usage: rx [--nw] [<name>] | rx --export [session]"

    set -l config_home $XDG_CONFIG_HOME
    test -n "$config_home"; or set config_home $HOME/.config
    set -l state_home $XDG_STATE_HOME
    test -n "$state_home"; or set state_home $HOME/.local/state
    set -l sessions_dir $config_home/rex/sessions
    # Written by the preexec hook in conf.d/rex.fish, one file per block
    set -l commands_dir $state_home/rx/commands

    # Prints the ID of the session labeled RX_NAME, creating it when missing.
    # Rex allows duplicate labels, so the lookup must come before session.create.
    # Inputs travel as environment variables because `rex do key=value` args
    # guess types: a session named "true" or "1" would not arrive as a string.
    set -l open_lua '
local name, root = os.getenv("RX_NAME"), os.getenv("RX_ROOT")
local def = os.getenv("RX_DEF")

local function call(method, args)
	local result, err = rex.call(method, args)
	if err ~= nil then error(method .. ": " .. err, 0) end
	return result
end

for _, s in ipairs(call("session.list").sessions or {}) do
	if s.label == name then return s.session_id end
end

local spec = {}
-- Rex returns nil, not "", for an empty environment variable
if def ~= nil and def ~= "" then
	spec = dofile(def)
	if type(spec) ~= "table" then error(def .. ": must return a table", 0) end
	root = spec.root or root
end

-- Blocks without a cwd start in the session root; relative ones resolve
-- against it, which keeps definitions short and portable.
local function place(node)
	if node.split then
		place(node.split.before)
		place(node.split.after)
	elseif node.block then
		local options = node.block.options or {}
		node.block.options = options
		if options.cwd == nil then
			options.cwd = root
		elseif options.cwd:sub(1, 1) ~= "/" then
			options.cwd = root .. "/" .. options.cwd
		end
	end
end

local windows = {}
local function add(list)
	for _, w in ipairs(list) do
		place(w.layout)
		table.insert(windows, { window_label = w.label, layout = w.layout })
	end
end

add(spec.windows or {})
if #windows == 0 then
	add({ { layout = rex.layout.block({ flavor = "com.superlogical.terminal.shell" }) } })
end

return call("session.create", { label = name, initial_windows = windows }).session_id
'

    # Prints a definition based on the target session. Rex reports only a
    # process's argv0, so exact commands come from the preexec hook files; a
    # running program without one becomes a comment. The block running this
    # export is skipped so `rx --export` does not replay itself.
    set -l export_lua '
local home = os.getenv("HOME")
local commands, self = os.getenv("RX_COMMANDS"), os.getenv("RX_SELF")
local terminal = "com.superlogical.terminal"

local view, err = rex.session.view({})
if err ~= nil then error(err, 0) end

local function q(s) return string.format("%q", s) end

local function home_expr(path)
	if path == home then return "os.getenv(\"HOME\")" end
	if path:sub(1, #home + 1) == home .. "/" then
		return "os.getenv(\"HOME\") .. " .. q(path:sub(#home + 1))
	end
	return q(path)
end

local function recorded(id)
	local f = io.open(commands .. "/" .. id)
	if f == nil then return nil end
	local command = f:read("*a"):gsub("\n$", "")
	f:close()
	if command ~= "" then return command end
end

local function process(id)
	local p = rex.block.call(terminal, "process", { block_id = id })
	return (p or {}).foreground or {}
end

local windows, root = {}, nil
for _, w in ipairs(view.windows) do
	local tiled, floating, flavors = nil, 0, {}
	for _, layer in ipairs(w.layers) do
		for _, b in ipairs(layer.blocks or {}) do flavors[b.block_id] = b.flavor end
		if layer.kind == "tiled" then tiled = layer.layout else floating = floating + 1 end
	end
	if tiled ~= nil then
		table.insert(windows, { label = w.label, layout = tiled, flavors = flavors, floating = floating })
	end
end

-- The directory of the first block becomes the root
local function first_block(node)
	if node.split then return first_block(node.split.before) end
	return node.block_id
end
if #windows == 0 then error("session has no windows to export", 0) end
root = process(first_block(windows[1].layout)).cwd or home

local function cwd_expr(cwd)
	if cwd == nil or cwd == root then return nil end
	if cwd:sub(1, #root + 1) == root .. "/" then return q(cwd:sub(#root + 2)) end
	return home_expr(cwd)
end

local function pad(n) return string.rep("\t", n) end

local function emit(node, flavors, depth)
	if node.split then
		local s = node.split
		return "rex.layout." .. s.direction .. "(\n"
			.. pad(depth + 1) .. tostring(s.ratio) .. ",\n"
			.. pad(depth + 1) .. emit(s.before, flavors, depth + 1) .. ",\n"
			.. pad(depth + 1) .. emit(s.after, flavors, depth + 1) .. "\n"
			.. pad(depth) .. ")"
	end
	local id = node.block_id
	local fg = process(id)
	local options = {}
	local cwd = cwd_expr(fg.cwd)
	if cwd ~= nil then table.insert(options, "cwd = " .. cwd) end
	local command = id ~= self and recorded(id) or nil
	local text = "rex.layout.block {\n"
	if command ~= nil then
		table.insert(options, "initial_input = " .. q(command .. "\n"))
	elseif fg.argv0 ~= nil and fg.argv0:sub(1, 1) ~= "-" then
		-- Login shells have a leading "-" in argv0; anything else is a program
		text = text .. pad(depth + 1) .. "-- running " .. fg.argv0:gsub("\n", " ") .. " (command not recorded)\n"
	end
	text = text .. pad(depth + 1) .. "flavor = " .. q(flavors[id] or "com.superlogical.terminal.shell") .. ",\n"
	if #options > 0 then
		text = text .. pad(depth + 1) .. "options = { " .. table.concat(options, ", ") .. " },\n"
	end
	return text .. pad(depth) .. "}"
end

local out = {
	"-- Generated by rx --export from session " .. q(view.label or view.session_id) .. ".",
	"-- Recorded commands are replayed. Review them for secrets before saving this file.",
	"-- Programs without a recorded command remain comments with their process names.",
	"",
	"return {",
	"\troot = " .. home_expr(root) .. ",",
	"\twindows = {",
}
for _, w in ipairs(windows) do
	table.insert(out, "\t\t{")
	if w.label ~= nil then table.insert(out, "\t\t\tlabel = " .. q(w.label) .. ",") end
	if w.floating > 0 then
		table.insert(out, "\t\t\t-- " .. w.floating .. " floating layer(s) not exported")
	end
	table.insert(out, "\t\t\tlayout = " .. emit(w.layout, w.flavors, 3) .. ",")
	table.insert(out, "\t\t},")
end
table.insert(out, "\t},")
table.insert(out, "}")
io.write(table.concat(out, "\n") .. "\n")
'

    # Shows session RX_ID in a new app window. client.window.new returns before
    # the window exists, and the window then opens a throwaway session of its
    # own; selecting before that would switch the old window instead. So wait
    # for the throwaway, select RX_ID in its place, then destroy it.
    set -l new_window_lua '
local id = os.getenv("RX_ID")

local function call(method, args)
	local result, err = rex.call(method, args)
	if err ~= nil then error(method .. ": " .. err, 0) end
	return result
end

local function ids()
	local set = {}
	for _, s in ipairs(call("session.list").sessions or {}) do set[s.session_id] = true end
	return set
end

local app
for _, c in ipairs(call("client.list").clients or {}) do
	if c.info and c.info.kind == "app" then
		if app ~= nil then error("several Rex apps are connected", 0) end
		app = c.client_id
	end
end
if app == nil then error("no Rex app is connected", 0) end

local function perform(action, args)
	return call("client.perform", { client_id = app, action = action, args = args })
end

local before = ids()
perform("client.window.new")

local fresh
for _ = 1, 100 do
	for sid in pairs(ids()) do
		if not before[sid] then fresh = sid end
	end
	if fresh ~= nil then break end
	rex.sleep(0.05)
end
if fresh == nil then error("new window never opened a session", 0) end

perform("session.select", { session_id = id })
-- The app gave the new window a throwaway session; destroying needs attachment
call("session.attach", { session_id = fresh })
call("session.destroy", { session_id = fresh })
'

    set -l name
    set -l root $PWD
    set -l session_file
    set -l new_window

    if set -l i (contains -i -- --nw $argv)
        set new_window 1
        set -e argv[$i]
    end

    if set -q new_window[1]; and contains -- "$argv[1]" --export -h --help
        echo $usage_text >&2
        return 64
    end

    switch "$argv[1]"
        case --export
            if test (count $argv) -gt 2
                echo $usage_text >&2
                return 64
            end
            set -l session $argv[2]
            if test -z "$session"
                if test -z "$REX_SESSION"
                    echo "rx: --export needs a session name outside Rex" >&2
                    return 64
                end
                set session $REX_SESSION
            end
            printf '%s\n' $export_lua | RX_COMMANDS=$commands_dir RX_SELF=$REX_BLOCK \
                $rex do -s $session -
            return $pipestatus[-1]
        case -h --help
            if test (count $argv) -ne 1
                echo $usage_text >&2
                return 64
            end
            echo $usage_text
            return 0
        case '-*'
            echo $usage_text >&2
            return 64
        case ''
            if test (count $argv) -gt 1
                echo $usage_text >&2
                return 64
            end
            set name (path basename $PWD)
        case '*'
            if test (count $argv) -ne 1
                echo $usage_text >&2
                return 64
            end
            set name $argv[1]
            if test -f $sessions_dir/$name.lua
                set session_file $sessions_dir/$name.lua
            else
                # A unique prefix stands for the whole definition name
                set -l matches $sessions_dir/$name*.lua
                if test (count $matches) -gt 1
                    echo "rx: '$name' matches several definitions:" >&2
                    path change-extension '' -- (path basename -- $matches) | sed 's/^/  /' >&2
                    return 64
                else if test (count $matches) -eq 1
                    set session_file $matches
                    set name (path change-extension '' -- (path basename -- $matches))
                end
            end
    end

    set -l id (printf '%s\n' $open_lua | RX_NAME=$name RX_ROOT=$root RX_DEF=$session_file \
        $rex do -)
    or return
    # rex do prints the returned string as JSON; session IDs never contain quotes
    set id (string replace -a '"' '' -- $id)

    if set -q new_window[1]
        printf '%s\n' $new_window_lua | RX_ID=$id $rex do - >/dev/null
    else if test -n "$REX_SESSION"
        $rex do session.select session_id=$id >/dev/null
    else
        $rex attach $id
    end
end
