-- URL dispatcher
-- Sets Hammerspoon as the default browser for HTTP/HTTPS links, and
-- dispatches them to different apps according to the patterns define
-- in the config. If no pattern matches, `default_handler` is used.

local mod = {}

mod.config = {
   patterns = {
      -- evaluated in the order they are declared. Entry format: { "url pattern", "application bundle ID" }
      -- e.g.
      --      { "https?://gmail.com", "com.google.Chrome" },
      --      { "https?://en.wikipedia.org", "org.epichrome.app.Wikipedia" },
   },
   -- Bundle ID for default URL handler
   default_handler = "com.apple.Safari",
   -- Handle Slack-redir URLs specially so that we apply the rule on the destination URL
   decode_slack_redir_urls = true,
}

-- Decode URLs
local hex_to_char = function(x)
   return string.char(tonumber(x, 16))
end

local unescape = function(url)
   return url:gsub("%%(%x%x)", hex_to_char)
end

-- Attempt at getting an app ID from either an ID or the app name. Not fully debugged yet.
function getAppId(app, launch)
   if launch == nil then
      launch = false
   end
   -- Convert to app name if it's a bundleID
   local name = hs.application.nameForBundleID(app)
   local appid = nil
   if name ~= nil then
      -- app is a valid bundleID, so we return it
      logger.df("Found an app with bundle ID %s: %s", app, name)
      appid = app
   else
      -- assume it's an app name, first try to find it running
      local appobj = hs.application.find(app)
      if appobj ~= nil then
         appid = appobj:bundleID()
         logger.df("Found a running app that matches %s: %s (bundle ID %s)", app, appobj:name(), appid)
      else
         if launch then
            -- as a last resort, try to launch it and then get its ID
            logger.df("Trying to launch app %s", app)
            if hs.application.launchOrFocus(app) then
               appobj = hs.application.find(app)
               logger.df("appobj = %s", hs.inspect(appobj))
               if appobj ~= nil then
                  logger.df("Found a running app that matches %s: %s (bundle ID %s)", app, appobj:name(), appid)
                  appid = appobj:bundleID()
               else
                  logger.df("%s launched successfully, but can't find it running", app)
               end
            else
               logger.ef("Launching app %s failed", app)
            end
         else
            logger.df("No running app matches '%s', launch=false so not trying to run one", app)
         end
      end
   end
   return appid
end

function mod.customHttpCallback(scheme, host, params, fullUrl)
   logger.df("Handling URL %s", fullUrl)
   local url = fullUrl
   if mod.config.decode_slack_redir_urls then
      local newUrl = string.match(url, 'https://slack.redir.net/.*url=(.*)')
      if newUrl then
         url = unescape(newUrl)
         logger.df("Got slack-redir URL, target URL: %s", url)
      end
   end
   for i,pair in ipairs(mod.config.patterns) do
      local p = pair[1]
      local app = pair[2]
      logger.df("Matching %s against %s", url, p)
      if string.match(url, p) then
         logger.df("  Match! Opening with %s", app)
         -- id = getAppId(app, true)
         id = app
         if id ~= nil then
            hs.urlevent.openURLWithBundle(url, id)
            return
         else
            logger.wf("I could not find an application that matches '%s', falling through to default handler", app)
         end
      end
   end
   hs.urlevent.openURLWithBundle(url, mod.config.default_handler)
end

function mod.init()
   hs.urlevent.httpCallback = mod.customHttpCallback
   hs.urlevent.setDefaultHandler('http')
end

return mod
