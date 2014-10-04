dofile("urlcode.lua")
dofile("table_show.lua")
JSON = (loadfile "JSON.lua")()

local url_count = 0
local tries = 0
local item_type = os.getenv('item_type')
local item_value = os.getenv('item_value')

local downloaded = {}

load_json_file = function(file)
  if file then
    local f = io.open(file)
    local data = f:read("*all")
    f:close()
    return JSON:decode(data)
  else
    return nil
  end
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

wget.callbacks.download_child_p = function(urlpos, parent, depth, start_url_parsed, iri, verdict, reason)
  local url = urlpos["url"]["url"]
  local html = urlpos["link_expect_html"]
  local parenturl = parent["url"]
  local html = nil
  
  if downloaded[url] == true then
    return false
  end
  
  if item_type == "image99pack" then
    if string.match(url, "/"..item_type.."[0-9][0-9]")
      or string.match(url, "/css/")
      or string.match(url, "/ajax/")
      or string.match(url, "/js/")
      or string.match(url, "/js_lib/")
      or string.match(url, "/img/")
      or string.match(url, "/wapi/")
      or string.match(url, "/offensive/")
      or string.match(url, "%.jpg")
      or string.match(url, "%.jpeg")
      or string.match(url, "%.png")
      or string.match(url, "%.gif")
      or string.match(url, "%.css")
      or string.match(url, "%.js")
      or string.match(url, "gstatic%.com")
      or string.match(url, "mw2%.google%.com")
      or string.match(url, "apis%.google%.com")
      or string.match(url, "static%.panoramio%.com")
      or string.match(url, "static%.panoramio%.com%.storage%.googleapis%.com")
      or string.match(url, "googleusercontent%.com")
      or string.match(url, "googleapis%.com") then
      return true
    else
      return false
    end
  end
    
end


wget.callbacks.get_urls = function(file, url, is_css, iri)
  local urls = {}
  local html = nil
  local photo = nil
  
  if item_type == "image99pack" then
    if (string.match(url, "/photos/") and string.match(url, "/"..item_value.."[0-9][0-9]%.")) then
      if string.match(url, "static%.panoramio%.com") then
        photo = string.match(url, "static%.panoramio%.com/photos/[^/]+/(.+)")
      elseif string.match(url, "static%.panoramio%.com%.storage%.googleapis%.com") then
        photo = string.match(url, "static%.panoramio%.com%.storage%.googleapis%.com/photos/[^/]+/(.+)")
      elseif string.match(url, "www%.panoramio%.com") then
        photo = string.match(url, "www%.panoramio%.com/photos/[^/]+/(.+)")
      elseif string.match(url, "ssl%.panoramio%.com") then
        photo = string.match(url, "ssl%.panoramio%.com/photos/[^/]+/(.+)")
      elseif string.match(url, "mw2%.google%.com") then
        photo = string.match(url, "static%.panoramio%.com/[^/]+/photos/[^/]+/(.+)")
      end
      if photo then
        local storage_mini_square = "http://static.panoramio.com.storage.googleapis.com/photos/mini_square/"..photo
        if downloaded[storage_mini_square] ~= true then
          table.insert(urls, { url=storage_mini_square })
        end
        local storage_square = "http://static.panoramio.com.storage.googleapis.com/photos/square/"..photo
        if downloaded[storage_square] ~= true then
          table.insert(urls, { url=storage_square })
        end
        local storage_thumbnail = "http://static.panoramio.com.storage.googleapis.com/photos/thumbnail/"..photo
        if downloaded[storage_thumbnail] ~= true then
          table.insert(urls, { url=storage_thumbnail })
        end
        local storage_small = "http://static.panoramio.com.storage.googleapis.com/photos/small/"..photo
        if downloaded[storage_small] ~= true then
          table.insert(urls, { url=storage_small })
        end
        local storage_medium = "http://static.panoramio.com.storage.googleapis.com/photos/medium/"..photo
        if downloaded[storage_medium] ~= true then
          table.insert(urls, { url=storage_medium })
        end
        local storage_large = "http://static.panoramio.com.storage.googleapis.com/photos/large/"..photo
        if downloaded[storage_large] ~= true then
          table.insert(urls, { url=storage_large })
        end
        local storage_original = "http://static.panoramio.com.storage.googleapis.com/photos/original/"..photo
        if downloaded[storage_original] ~= true then
          table.insert(urls, { url=storage_original })
        end
        local storage_1920x1280 = "http://static.panoramio.com.storage.googleapis.com/photos/1920x1280/"..photo
        if downloaded[storage_1920x1280] ~= true then
          table.insert(urls, { url=storage_1920x1280 })
        end
        
        
        
        
        local static_mini_square = "http://static.panoramio.com/photos/mini_square/"..photo
        if downloaded[static_mini_square] ~= true then
          table.insert(urls, { url=static_mini_square })
        end
        local static_square = "http://static.panoramio.com/photos/square/"..photo
        if downloaded[static_square] ~= true then
          table.insert(urls, { url=static_square })
        end
        local static_thumbnail = "http://static.panoramio.com/photos/thumbnail/"..photo
        if downloaded[static_thumbnail] ~= true then
          table.insert(urls, { url=static_thumbnail })
        end
        local static_small = "http://static.panoramio.com/photos/small/"..photo
        if downloaded[static_small] ~= true then
          table.insert(urls, { url=static_small })
        end
        local static_medium = "http://static.panoramio.com/photos/medium/"..photo
        if downloaded[static_medium] ~= true then
          table.insert(urls, { url=static_medium })
        end
        local static_large = "http://static.panoramio.com/photos/large/"..photo
        if downloaded[static_large] ~= true then
          table.insert(urls, { url=static_large })
        end
        local static_original = "http://static.panoramio.com/photos/original/"..photo
        if downloaded[static_original] ~= true then
          table.insert(urls, { url=static_original })
        end
        local static_1920x1280 = "http://static.panoramio.com/photos/1920x1280/"..photo
        if downloaded[static_1920x1280] ~= true then
          table.insert(urls, { url=static_1920x1280 })
        end
        
        
        
        local ssl_mini_square = "http://ssl.panoramio.com/photos/mini_square/"..photo
        if downloaded[ssl_mini_square] ~= true then
          table.insert(urls, { url=ssl_mini_square })
        end
        local ssl_square = "http://ssl.panoramio.com/photos/square/"..photo
        if downloaded[ssl_square] ~= true then
          table.insert(urls, { url=ssl_square })
        end
        local ssl_thumbnail = "http://ssl.panoramio.com/photos/thumbnail/"..photo
        if downloaded[ssl_thumbnail] ~= true then
          table.insert(urls, { url=ssl_thumbnail })
        end
        local ssl_small = "http://ssl.panoramio.com/photos/small/"..photo
        if downloaded[ssl_small] ~= true then
          table.insert(urls, { url=ssl_small })
        end
        local ssl_medium = "http://ssl.panoramio.com/photos/medium/"..photo
        if downloaded[ssl_medium] ~= true then
          table.insert(urls, { url=ssl_medium })
        end
        local ssl_large = "http://ssl.panoramio.com/photos/large/"..photo
        if downloaded[ssl_large] ~= true then
          table.insert(urls, { url=ssl_large })
        end
        local ssl_original = "http://ssl.panoramio.com/photos/original/"..photo
        if downloaded[ssl_original] ~= true then
          table.insert(urls, { url=ssl_original })
        end
        local ssl_1920x1280 = "http://ssl.panoramio.com/photos/1920x1280/"..photo
        if downloaded[ssl_1920x1280] ~= true then
          table.insert(urls, { url=ssl_1920x1280 })
        end
        
        
        
        local www_mini_square = "http://www.panoramio.com/photos/mini_square/"..photo
        if downloaded[www_mini_square] ~= true then
          table.insert(urls, { url=www_mini_square })
        end
        local www_square = "http://www.panoramio.com/photos/square/"..photo
        if downloaded[www_square] ~= true then
          table.insert(urls, { url=www_square })
        end
        local www_thumbnail = "http://www.panoramio.com/photos/thumbnail/"..photo
        if downloaded[www_thumbnail] ~= true then
          table.insert(urls, { url=www_thumbnail })
        end
        local www_small = "http://www.panoramio.com/photos/small/"..photo
        if downloaded[www_small] ~= true then
          table.insert(urls, { url=www_small })
        end
        local www_medium = "http://www.panoramio.com/photos/medium/"..photo
        if downloaded[www_medium] ~= true then
          table.insert(urls, { url=www_medium })
        end
        local www_large = "http://www.panoramio.com/photos/large/"..photo
        if downloaded[www_large] ~= true then
          table.insert(urls, { url=www_large })
        end
        local www_original = "http://www.panoramio.com/photos/original/"..photo
        if downloaded[www_original] ~= true then
          table.insert(urls, { url=www_original })
        end
        local www_1920x1280 = "http://www.panoramio.com/photos/1920x1280/"..photo
        if downloaded[www_1920x1280] ~= true then
          table.insert(urls, { url=www_1920x1280 })
        end
        
        
        
        local mw2_mini_square = "http://mw2.google.com/mw-panoramio/photos/mini_square/"..photo
        if downloaded[mw2_mini_square] ~= true then
          table.insert(urls, { url=mw2_mini_square })
        end
        local mw2_square = "http://mw2.google.com/mw-panoramio/photos/square/"..photo
        if downloaded[mw2_square] ~= true then
          table.insert(urls, { url=mw2_square })
        end
        local mw2_thumbnail = "http://mw2.google.com/mw-panoramio/photos/thumbnail/"..photo
        if downloaded[mw2_thumbnail] ~= true then
          table.insert(urls, { url=mw2_thumbnail })
        end
        local mw2_small = "http://mw2.google.com/mw-panoramio/photos/small/"..photo
        if downloaded[mw2_small] ~= true then
          table.insert(urls, { url=mw2_small })
        end
        local mw2_medium = "http://mw2.google.com/mw-panoramio/photos/medium/"..photo
        if downloaded[mw2_medium] ~= true then
          table.insert(urls, { url=mw2_medium })
        end
      end
    end
    for baseurl in string.gmatch(url, "(http[s]?://static%.panoramio%.com/avatars/user/[0-9]+%.jpg)%?v=") do
      if downloaded[baseurl] ~= true then
        table.insert(urls, { url=baseurl })
      end
    end
    if string.match(url, "/"..item_value.."[0-9][0-9]")
      or string.match(url, "/"..item_value.."[0-9][0-9]&") 
      or string.match(url, "/"..item_value.."[0-9][0-9]%?") then
      html = read_file(file)
      for customurl in string.gmatch(html, '"(http[s]?://[^"]+)"') do
        if string.match(customurl, "/"..item_value.."[0-9][0-9]")
          or string.match(customurl, "/css/")
          or string.match(customurl, "/ajax/")
          or string.match(customurl, "/js/")
          or string.match(customurl, "/js_lib/")
          or string.match(customurl, "/img/")
          or string.match(customurl, "/wapi/")
          or string.match(customurl, "/map/")
          or string.match(customurl, "/offensive/")
          or string.match(customurl, "/map_photo/")
          or string.match(customurl, "with_photo_id="..item_value.."[0-9][0-9]")
          or string.match(customurl, "/photo_explorer")
          or string.match(customurl, "%.jpg")
          or string.match(customurl, "%.jpeg")
          or string.match(customurl, "%.png")
          or string.match(customurl, "%.gif")
          or string.match(customurl, "%.css")
          or string.match(customurl, "%.js")
          or string.match(customurl, "gstatic%.com")
          or string.match(customurl, "mw2%.google%.com")
          or string.match(customurl, "apis%.google%.com")
          or string.match(customurl, "static%.panoramio%.com")
          or string.match(customurl, "static%.panoramio%.com%.storage%.googleapis%.com")
          or string.match(customurl, "googleusercontent%.com")
          or string.match(customurl, "googleapis%.com") then
          if not string.match(customurl, "twitter%.com") then
            if downloaded[customurl] ~= true then
              table.insert(urls, { url=customurl })
            end
          end
        end
      end
      for customurlnf in string.gmatch(html, '"(/[^"]+)"') do
--        if string.match(customurlnf, "//") then
--          local newurl = string.gsub(customurlnf, "//", "http://")
--          if downloaded[newurl] ~= true then
--            table.insert(urls, { url=newurl })
--          end
        if string.match(customurlnf, "/"..item_value.."[0-9][0-9]")
          or string.match(customurlnf, "/css/")
          or string.match(customurlnf, "/ajax/")
          or string.match(customurlnf, "/js/")
          or string.match(customurlnf, "/js_lib/")
          or string.match(customurlnf, "/img/")
          or string.match(customurlnf, "/wapi/")
          or string.match(customurlnf, "/map/")
          or string.match(customurlnf, "/offensive/")
          or string.match(customurlnf, "/map_photo/")
          or string.match(customurlnf, "with_photo_id="..item_value.."[0-9][0-9]")
          or string.match(customurlnf, "/photo_explorer")
          or string.match(customurlnf, "%.jpg")
          or string.match(customurlnf, "%.jpeg")
          or string.match(customurlnf, "%.png")
          or string.match(customurlnf, "%.gif")
          or string.match(customurlnf, "%.css")
          or string.match(customurlnf, "%.js") then
          if string.match(customurlnf, "//[^%.]+%.googleusercontent") then
            local customurl = string.gsub(custonurlnf, "//", "http://")
            if downloaded[customurl] ~= true then
              table.insert(urls, { url=customurl })
            end
          else
            local base = "http://www.panoramio.com"
            local customurl = base..customurlnf
            if downloaded[customurl] ~= true then
              table.insert(urls, { url=customurl })
            end
          end
        end
      end
      for customurlnf in string.gmatch(html, "'(/[^']+)'") do
--        if string.match(customurlnf, "//") then
--          local newurl = string.gsub(customurlnf, "//", "http://")
--          if downloaded[newurl] ~= true then
--            table.insert(urls, { url=newurl })
--          end
        if string.match(customurlnf, "/"..item_value.."[0-9][0-9]")
          or string.match(customurlnf, "/css/")
          or string.match(customurlnf, "/ajax/")
          or string.match(customurlnf, "/js/")
          or string.match(customurlnf, "/js_lib/")
          or string.match(customurlnf, "/img/")
          or string.match(customurlnf, "/wapi/")
          or string.match(customurlnf, "/map/")
          or string.match(customurlnf, "/offensive/")
          or string.match(customurlnf, "/map_photo/")
          or string.match(customurlnf, "with_photo_id="..item_value.."[0-9][0-9]")
          or string.match(customurlnf, "/photo_explorer")
          or string.match(customurlnf, "%.jpg")
          or string.match(customurlnf, "%.jpeg")
          or string.match(customurlnf, "%.png")
          or string.match(customurlnf, "%.gif")
          or string.match(customurlnf, "%.css")
          or string.match(customurlnf, "%.js") then
          if string.match(customurlnf, "//[^%.]+%.googleusercontent") then
            local customurl = string.gsub(custonurlnf, "//", "http://")
            if downloaded[customurl] ~= true then
              table.insert(urls, { url=customurl })
            end
          else
            local base = "http://www.panoramio.com"
            local customurl = base..customurlnf
            if downloaded[customurl] ~= true then
              table.insert(urls, { url=customurl })
            end
          end
        end
      end
    end
  end
  
  return urls
end
  

wget.callbacks.httploop_result = function(url, err, http_stat)
  -- NEW for 2014: Slightly more verbose messages because people keep
  -- complaining that it's not moving or not working
  local status_code = http_stat["statcode"]
  
  url_count = url_count + 1
  io.stdout:write(url_count .. "=" .. status_code .. " " .. url["url"] .. ".  \n")
  io.stdout:flush()
  
  if (status_code >= 200 and status_code <= 399) then
    downloaded[url.url] = true
  end
  
  if string.match(url["url"], "with_photo_id")
    or string.match(url["url"], "www%.panoramio%.com/photos/mini_square/") 
    or string.match(url["url"], "www%.panoramio%.com/photos/square/") 
    or string.match(url["url"], "www%.panoramio%.com/photos/thumbnail/") 
    or string.match(url["url"], "www%.panoramio%.com/photos/small/") 
    or string.match(url["url"], "www%.panoramio%.com/photos/medium/") 
    or string.match(url["url"], "www%.panoramio%.com/photos/large/") 
    or string.match(url["url"], "www%.panoramio%.com/photos/original/") 
    or string.match(url["url"], "www%.panoramio%.com/photos/1920x1280/")
    or string.match(url["url"], "ssl%.panoramio%.com/photos/mini_square/") 
    or string.match(url["url"], "ssl%.panoramio%.com/photos/square/") 
    or string.match(url["url"], "ssl%.panoramio%.com/photos/thumbnail/") 
    or string.match(url["url"], "ssl%.panoramio%.com/photos/small/") 
    or string.match(url["url"], "ssl%.panoramio%.com/photos/medium/") 
    or string.match(url["url"], "ssl%.panoramio%.com/photos/large/") 
    or string.match(url["url"], "/signin/") 
    or string.match(url["url"], "/signup/") 
    or string.match(url["url"], "http[s]?://%%") 
    or string.match(url["url"], "ssl%.panoramio%.com/photos/original/") 
    or string.match(url["url"], "ssl%.panoramio%.com/photos/1920x1280/") then
    return wget.actions.EXIT
  elseif status_code == 400 and string.match(url["url"], "googleapis") then
    return wget.actions.EXIT
  elseif status_code >= 500 or
    (status_code >= 400 and status_code ~= 404 and status_code ~= 403) then
    io.stdout:write("\nServer returned "..http_stat.statcode..". Sleeping.\n")
    io.stdout:flush()

    os.execute("sleep 1")

    tries = tries + 1

    if tries >= 20 then
      io.stdout:write("\nI give up...\n")
      io.stdout:flush()
      return wget.actions.ABORT
    else
      return wget.actions.CONTINUE
    end
  elseif status_code == 0 then
    io.stdout:write("\nServer returned "..http_stat.statcode..". Sleeping.\n")
    io.stdout:flush()

    os.execute("sleep 10")

    tries = tries + 1

    if tries >= 10 then
      io.stdout:write("\nI give up...\n")
      io.stdout:flush()
      return wget.actions.ABORT
    else
      return wget.actions.CONTINUE
    end
  end

  tries = 0

  -- We're okay; sleep a bit (if we have to) and continue
  -- local sleep_time = 0.1 * (math.random(75, 1000) / 100.0)
  local sleep_time = 0

  --  if string.match(url["host"], "cdn") or string.match(url["host"], "media") then
  --    -- We should be able to go fast on images since that's what a web browser does
  --    sleep_time = 0
  --  end

  if sleep_time > 0.001 then
    os.execute("sleep " .. sleep_time)
  end

  return wget.actions.NOTHING
end
