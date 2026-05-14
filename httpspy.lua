--[[
    made by vanish
]]

if rconsoleprint then
    rconsoleprint("  _  _ ___ _____ ___   ___ _____   __\n")
    rconsoleprint(" | || |_ _|_   _| _ \\ / __| _ \\ \\ / /\n")
    rconsoleprint(" | __ || |  | | |  _/ \\__ \\  _/\\ V / \n")
    rconsoleprint(" |_||_|___| |_| |_|   |___/_|   |_|  \n")
    rconsoleprint("\n")
    rconsoleprint("\n")
end

assert(syn or http, "Unsupported exploit (needs syn.request or http.request)")

--- @class Options
--- @field AutoDecode boolean    auto JSON decode response body
--- @field Highlighting boolean  syntax highlighting in console
--- @field SaveLogs boolean      write logs to file
--- @field CLICommands boolean   enable CLI commands
--- @field ShowResponse boolean  print response data
--- @field BlockedURLs table    URLs to block { [url] = true }
--- @field API boolean           return API table

--- @type Options
local _opts = ({...})[1] or {
    AutoDecode   = true,
    Highlighting = true,
    SaveLogs     = true,
    CLICommands  = true,
    ShowResponse = true,
    BlockedURLs  = {},
    API          = true,
}

local _ver  = "v1.1.3"
local _logf = string.format("%d-%s-log.txt", game.PlaceId, os.date("%d_%m_%y"))

if _opts.SaveLogs then
    writefile(_logf, string.format("HttpSpy Logs - %s\n\n", os.date("%d/%m/%y")))
end

--- @type table  leopard serializer
local _S = loadstring(game:HttpGet("https://raw.githubusercontent.com/e9d464a3-9920-4dda-96f0-b0d2a85d9d64/Code/refs/heads/main/s3r.lua"))()

local _cf  = clonefunction
local _rcp = _cf(rconsoleprint)
local _fmt = _cf(string.format)
local _gsb = _cf(string.gsub)
local _mat = _cf(string.match)
local _apf = _cf(appendfile)
local _typ = _cf(type)
local _crn = _cf(coroutine.running)
local _cwp = _cf(coroutine.wrap)
local _crm = _cf(coroutine.resume)
local _cyd = _cf(coroutine.yield)
local _pca = _cf(pcall)
local _prs = _cf(pairs)
local _err = _cf(error)

--- @type table  { [url] = true } blocked URLs
local _blk = _opts.BlockedURLs
local _on  = true

--- @type function  underlying request function
local _req = (syn or http).request
local _lib = syn and "syn" or "http"

--- @type table  { [url] = fn(response) }
local _hkd = {}
--- @type table  { [host] = proxyhost }
local _prx = {}

--- @type table  namecall methods to intercept
local _mth = {
    HttpGet       = not syn,
    HttpGetAsync  = not syn,
    GetObjects    = true,
    HttpPost      = not syn,
    HttpPostAsync = not syn,
}

_S.UpdateConfig({ highlighting = _opts.Highlighting })

--- @type string  latest commit message
-- local _cmt = game.HttpService:JSONDecode(
--     game:HttpGet("https://api.github.com/repos/NotDSF/HttpSpy/commits?per_page=1&path=init.lua")
-- )[1].commit.message

--- @type BindableEvent
local _evt = Instance.new("BindableEvent")

--- print to console + append to log (strips ANSI for file)
--- @param ... any
local function _pf(...)
    if _opts.SaveLogs then
        _apf(_logf, _gsb(_fmt(...), "%\27%[%d+m", ""))
    end
    return _rcp(_fmt(...))
end

--- scan GC for closure containing constant c in the saveinstance script env
--- @param c any
--- @return function|nil
local function _cscan(c)
    for _, v in _prs(getgc(true)) do
        if type(v) == "function"
            and islclosure(v)
            and getfenv(v).script == getfenv(saveinstance).script
            and table.find(debug.getconstants(v), c)
        then
            return v
        end
    end
end

--- recursively deep clone a table
--- @param t table
--- @param c table?
--- @return table
local function _dc(t, c)
    c = c or {}
    for i, v in _prs(t) do
        c[i] = _typ(v) == "table" and _dc(v) or v
    end
    return c
end

-- intercept namecall methods (HttpGet, HttpPost, GetObjects, ...)
local _nm
_nm = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local m = getnamecallmethod()
    if _mth[m] then
        _pf("game:%s(%s)\n\n", m, _S.FormatArguments(...))
    end
    return _nm(self, ...)
end))

-- intercept syn/http request
local _rq
--- @param req table  { Url, Method, Headers, Body }
_rq = hookfunction(_req, newcclosure(function(req)
    if _typ(req) ~= "table" then return _rq(req) end

    local _rd = _dc(req)
    if not _on then return _rq(req) end
    if _typ(_rd.Url) ~= "string" then return _rq(req) end

    if not _opts.ShowResponse then
        _pf("%s.request(%s)\n\n", _lib, _S.Serialize(_rd))
        return _rq(req)
    end

    local _t = _crn()
    _cwp(function()
        if _rd.Url and _blk[_rd.Url] then
            _pf("%s.request(%s) -- blocked\n\n", _lib, _S.Serialize(_rd))
            return _crm(_t, {})
        end

        if _rd.Url then
            local _h = string.match(_rd.Url, "https?://(%w+.%w+)/")
            if _h and _prx[_h] then
                _rd.Url = _gsb(_rd.Url, _h, _prx[_h], 1)
            end
        end

        _evt:Fire(_rd)

        local _ok, _rs = _pca(_rq, _rd)
        if not _ok then _err(_rs, 0) end

        local _bk = {}
        for i, v in _prs(_rs) do _bk[i] = v end

        if _bk.Headers["Content-Type"]
            and _mat(_bk.Headers["Content-Type"], "application/json")
            and _opts.AutoDecode
        then
            local _dok, _drs = _pca(game.HttpService.JSONDecode, game.HttpService, _bk.Body)
            if _dok then _bk.Body = _drs end
        end

        _pf("%s.request(%s)\n\nResponse: %s\n\n", _lib, _S.Serialize(_rd), _S.Serialize(_bk))
        _crm(_t, _hkd[_rd.Url] and _hkd[_rd.Url](_rs) or _rs)
    end)()
    return _cyd()
end))

if request then
    replaceclosure(request, _req)
end

if syn and syn.websocket then
    local _wsc, _wsb = debug.getupvalue(syn.websocket.connect, 1)
    _wsb = hookfunction(_wsc, function(...)
        _pf("syn.websocket.connect(%s)\n\n", _S.FormatArguments(...))
        return _wsb(...)
    end)
end

if syn and syn.websocket then
    local _hg
    _hg = hookfunction(getupvalue(_cscan("ZeZLm2hpvGJrD6OP8A3aEszPNEw8OxGb"), 2), function(self, ...)
        _pf("game:HttpGet(%s)\n\n", _S.FormatArguments(...))
        return _hg(self, ...)
    end)

    local _hp
    _hp = hookfunction(getupvalue(_cscan("gpGXBVpEoOOktZWoYECgAY31o0BlhOue"), 2), function(self, ...)
        _pf("game:HttpPost(%s)\n\n", _S.FormatArguments(...))
        return _hp(self, ...)
    end)
end

for m, en in _prs(_mth) do
    if en then
        local _b
        _b = hookfunction(game[m], newcclosure(function(self, ...)
            _pf("game.%s(game, %s)\n\n", m, _S.FormatArguments(...))
            return _b(self, ...)
        end))
    end
end

if not debug.info(2, "f") then
    _rcp("[HttpSpy] warning: outdated version detected\n")
end

_rcp(_fmt(
    " changelog : %s\n" ..
    " logs      : %s\n\n",
    _cmt,
    _opts.SaveLogs and _logf or "disabled"
))

if not _opts.API then return end

--- @class HttpSpyAPI
local API = {}

--- fires on every intercepted request
--- @type RBXScriptSignal
API.OnRequest = _evt.Event

--- hook a URL so its response passes through a callback
--- @param url string
--- @param hook function  fn(response) -> response
function API:HookSynRequest(url, hook)
    _hkd[url] = hook
end

--- rewrite all requests to host through proxy
--- @param host string
--- @param proxy string
function API:ProxyHost(host, proxy)
    _prx[host] = proxy
end

--- remove an active proxy
--- @param host string
function API:RemoveProxy(host)
    if not _prx[host] then _err("host isn't proxied", 0) end
    _prx[host] = nil
end

--- remove a URL hook
--- @param url string
function API:UnHookSynRequest(url)
    if not _hkd[url] then _err("url isn't hooked", 0) end
    _hkd[url] = nil
end

--- block a URL from being requested
--- @param url string
function API:BlockUrl(url)
    _blk[url] = true
end

--- unblock a URL
--- @param url string
function API:WhitelistUrl(url)
    _blk[url] = false
end

return API
