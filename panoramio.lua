dofile("urlcode.lua")
dofile("table_show.lua")

local url_count = 0
local tries = 0
local item_type = os.getenv('item_type')
local item_value = os.getenv('item_value')
local item_dir = os.getenv('item_dir')
local warc_file_base = os.getenv('warc_file_base')

local downloaded = {}
local addedtolist = {}

local ids = {}

for ignore in io.open("ignore-list", "r"):lines() do
  downloaded[ignore] = true
end

start, end_ = string.match(item_value, "([0-9]+)-([0-9]+)")
for i=start, end_ do
  ids[i] = true
end

read_file = function(file)
  if file then
    local f = assert(io.open(file))
    local data = f:read("*all")
    f:close()
    return data
  else
    return ""
  end
end

allowed = function(url)
  for s in string.gmatch(url, "([0-9]+)") do
    if ids[tonumber(s)] == true
       and (string.match(url, "^https?://[^/]*panoramio%.com")
        or string.match(url, "^https?://mw2%.google%.com/mw%-panoramio"))
       and not (string.match(url, "/signin/%?referer=")
        or string.match(url, "/twitter/photo_id")
        or string.match(url, "^https?://[^/]*panoramio%.com/photo/[0-9]+/$")
        or string.match(url, "^https?://[^/]*panoramio%.com/user/[0-9]+/$")
        or string.match(url, "^https?://[^/]*panoramio%.com/user/[0-9]+.*comment_page=[2-9][0-9]*")) then
      return true
    elseif string.match(url, "^https?://[^/]*panoramio%.com/map/%?place=")
       or string.match(url, "^https?://[^/]*panoramio%.com/kml/%?place=") then
      return true
    end
  end
  return false
end

wget.callbacks.download_child_p = function(urlpos, parent, depth, start_url_parsed, iri, verdict, reason)
  local url = urlpos["url"]["url"]
  local html = urlpos["link_expect_html"]

  if (downloaded[url] ~= true and addedtolist[url] ~= true)
     and (allowed(url) or (html == 0
      and not (string.match(url, "^https?://static%.panoramio%.com/photos/[^/]+/[0-9]+")
       or string.match(url, "^https?://static%.panoramio%.com/avatars/user/[0-9]+")
       or string.match(url, "^https?://[^/]*googleusercontent%.com/")
       or string.match(url, "^https?://mw2%.google%.com/mw%-panoramio/photos/[^/]+/[0-9]+")
       or string.match(url, "^https?://static%.panoramio%.com%.storage%.googleapis%.com/photos/[^/]+/[0-9]+")
       or string.match(url, "^https?://www%.panoramio%.com/photos/[^/]+/[0-9]+")
       or string.match(url, "^https?://ssl%.panoramio%.com/photos/[^/]+/[0-9]+")
       or string.match(url, "^https?://[^/]*panoramio%.com/photo/[0-9]+/")))) then
    addedtolist[url] = true
    return true
  else
    return false
  end
end

wget.callbacks.get_urls = function(file, url, is_css, iri)
  local urls = {}
  local html = nil

  downloaded[url] = true
  
  local function check(urla)
    local origurl = url
    local url = string.match(urla, "^([^#]+)")
    if (downloaded[url] ~= true and addedtolist[url] ~= true)
       and (allowed(url)
        or string.match(origurl, "/kml/")
        or string.match(origurl, "%.kml")) then
      if string.match(url, "&amp;") then
        table.insert(urls, { url=string.gsub(url, "&amp;", "&") })
        addedtolist[url] = true
        addedtolist[string.gsub(url, "&amp;", "&")] = true
      else
        table.insert(urls, { url=url })
        addedtolist[url] = true
      end
    end
  end

  local function checknewurl(newurl)
    if string.match(newurl, "^https?:////") then
      check(string.gsub(newurl, ":////", "://"))
    elseif string.match(newurl, "^https?://") then
      check(newurl)
    elseif string.match(newurl, "^https?:\\/\\/") then
      check(string.gsub(newurl, "\\", ""))
    elseif string.match(newurl, "^\\/\\/") then
      check(string.match(url, "^(https?:)")..string.gsub(newurl, "\\", ""))
    elseif string.match(newurl, "^//") then
      check(string.match(url, "^(https?:)")..newurl)
    elseif string.match(newurl, "^\\/") then
      check(string.match(url, "^(https?://[^/]+)")..string.gsub(newurl, "\\", ""))
    elseif string.match(newurl, "^/") then
      check(string.match(url, "^(https?://[^/]+)")..newurl)
    end
  end

  local function checknewshorturl(newurl)
    if string.match(newurl, "^%?") then
      check(string.match(url, "^(https?://[^%?]+)")..newurl)
    elseif not (string.match(newurl, "^https?:\\?/\\?//?/?")
        or string.match(newurl, "^[/\\]")
        or string.match(newurl, "^[jJ]ava[sS]cript:")
        or string.match(newurl, "^[mM]ail[tT]o:")
        or string.match(newurl, "^%${")) then
      check(string.match(url, "^(https?://.+/)")..newurl)
    end
  end

  if string.match(url, "^https?://[^/]*panoramio%.com/map/%?place=") then
    check(string.gsub(url, "map", "kml"))
  elseif string.match(url, "^https?://static%.panoramio%.com/photos/[^/]+/[^/]+$") then
    local photo = string.match(url, "^https?://static%.panoramio%.com/photos/[^/]+/([^%?]+)")
    check("http://www.panoramio.com/photos/mini_square/" .. photo)
    check("http://www.panoramio.com/photos/square/" .. photo)
    check("http://www.panoramio.com/photos/thumbnail/" .. photo)
    check("http://www.panoramio.com/photos/small/" .. photo)
    check("http://www.panoramio.com/photos/medium/" .. photo)
    check("http://www.panoramio.com/photos/large/" .. photo)
    check("http://www.panoramio.com/photos/1920x1280/" .. photo)
    check("http://www.panoramio.com/photos/original/" .. photo)
    --check("http://www.panoramio.com/photos/d/" .. photo)
  end
  
  if allowed(url)
     and not (string.match(url, "^https?://mw2%.google%.com")
      or string.match(url, "^https?://static%.panoramio%.com")) then
    html = read_file(file)
    if string.match(url, "/kml/")
       or string.match(url, "%.kml") then
      if string.match(html, "<href>([^<]+)<") then
        check(string.match(html, "<href>([^<]+)<"))
      end
    end
    for newurl in string.gmatch(html, '([^"]+)') do
      checknewurl(newurl)
    end
    for newurl in string.gmatch(html, "([^']+)") do
      checknewurl(newurl)
    end
    for newurl in string.gmatch(html, ">%s*([^<%s]+)") do
      checknewurl(newurl)
    end
    for newurl in string.gmatch(html, "href='([^']+)'") do
      checknewshorturl(newurl)
    end
    for newurl in string.gmatch(html, 'href="([^"]+)"') do
      checknewshorturl(newurl)
    end
  end

  return urls
end
  

wget.callbacks.httploop_result = function(url, err, http_stat)
  -- NEW for 2014: Slightly more verbose messages because people keep
  -- complaining that it's not moving or not working
  status_code = http_stat["statcode"]
  
  url_count = url_count + 1
  io.stdout:write(url_count .. "=" .. status_code .. " " .. url["url"] .. ".  \n")
  io.stdout:flush()

  if (status_code >= 200 and status_code <= 399) then
    if string.match(url.url, "https://") then
      local newurl = string.gsub(url.url, "https://", "http://")
      downloaded[newurl] = true
    else
      downloaded[url.url] = true
    end
  end

  if status_code == 302
     and string.match(url["url"], "^https?://[^/]*panoramio%.com/map_photo/%?id=[0-9]+$") then
    return wget.actions.EXIT
  end

  if status_code == 301 and string.match(url["url"], "^http://www%.panoramio%.com/photos/[^/]+/") then
    local image = string.match(url["url"], "^http://www%.panoramio%.com(/photos/[^/]+/.+)$")
    if downloaded["http://static.panoramio.com" .. image] == true
       or downloaded["http://mw2.google.com/mw-panoramio" .. image] == true
       or addedtolist["http://mw2.google.com/mw-panoramio" .. image] == true
       or addedtolist["http://static.panoramio.com" .. image] == true then
      return wget.actions.EXIT
    end
  end
  
  if status_code >= 500 or
    (status_code >= 400 and status_code ~= 404) or
    status_code == 0 then
    io.stdout:write("Server returned "..http_stat.statcode.." ("..err.."). Sleeping.\n")
    io.stdout:flush()
    os.execute("sleep 1")
    tries = tries + 1
    if tries >= 5 then
      io.stdout:write("\nI give up...\n")
      io.stdout:flush()
      tries = 0
      if allowed(url["url"]) then
        return wget.actions.ABORT
      else
        return wget.actions.EXIT
      end
    else
      return wget.actions.CONTINUE
    end
  end

  tries = 0

  local sleep_time = 0

  if sleep_time > 0.001 then
    os.execute("sleep " .. sleep_time)
  end

  return wget.actions.NOTHING
end