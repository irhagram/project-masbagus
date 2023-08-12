--- @class Locale
--- @field fallback Locale | boolean
--- @field warnOnMissing boolean
--- @field phrases table
--- @field currentLocale string
--- @field new fun(_: Locale, opts: table<string, any>): Locale
--- @field extend fun(self: Locale, phrases: table<string, string>, prefix: string?)
--- @field clear fun(self: Locale)
--- @field replace fun(self: Locale, phrases: table<string, any>)
--- @field locale fun(self: Locale, newLocale: string): string
--- @field t fun(self: Locale, key: string, subs: table<string, any>?): string
--- @field has fun(self: Locale, key: string): boolean
--- @field delete fun(self: Locale, phraseTarget: string | table, prefix: string)
Locale = {}
Locale.__index = Locale

--- Translate a key
--- @param phrase string
--- @param subs table
--- @return string
local function translateKey(phrase, subs)
    if type(phrase) ~= 'string' then
        error('TypeError: translateKey function expects arg #1 to be a string')
    end

    -- Substituions
    if not subs then
        return phrase
    end

    -- We should be escaping gsub just in case of any
    -- shenanigans with nested template patterns or injection

    -- Create and copy our return string
    local result = phrase

    -- Initial Scan over result looking for substituions
    for k, v in pairs(subs) do
        local templateToFind = '%%{' .. k .. '}'
        result = result:gsub(templateToFind, tostring(v)) -- string to allow all types
    end

    return result
end

--- Constructor function for a new Locale class instance
--- @param _ Locale kept for backwards compatibility
--- @param opts table<string, any> - Constructor opts param
--- @return Locale
function Locale.new(_, opts)
    local self = setmetatable({}, Locale)

    self.fallback = opts.fallbackLang and Locale.new({}, {
        warnOnMissing = false,
        phrases = opts.fallbackLang.phrases,
    }) or false

    self.warnOnMissing = type(opts.warnOnMissing) ~= 'boolean' and true or opts.warnOnMissing

    self.phrases = {}
    self:extend(opts.phrases or {})

    return self
end

--- Method for extending an instances phrases map. This is also, used
--- internally for initial population of phrases field.
--- @param phrases table<string, string> - Table of phrase definitions
--- @param prefix string | nil - Optional prefix used for recursive calls
function Locale:extend(phrases, prefix)
    for key, phrase in pairs(phrases) do
        local prefixKey = prefix and ('%s.%s'):format(prefix, key) or key
        -- If this is a nested table, we need to go reeeeeeeeeeeecursive
        if type(phrase) == 'table' then
            self:extend(phrase, prefixKey)
        else
            self.phrases[prefixKey] = phrase
        end
    end
end

--- Clear locale instance phrases
--- Might be useful for memory management of large phrase maps.
function Locale:clear()
    self.phrases = {}
end

--- Clears all phrases and replaces it with the passed phrases table
--- @param phrases table<string, any>
function Locale:replace(phrases)
    phrases = phrases or {}
    self:clear()
    self:extend(phrases)
end

--- Gets & Sets a locale depending on if an argument is passed
--- @param newLocale string - Optional new locale to set
--- @return string
function Locale:locale(newLocale)
    if newLocale then
        self.currentLocale = newLocale
    end
    return self.currentLocale
end

--- Primary translation method for a phrase of given key
--- @param key string - The phrase key to target
--- @param subs table<string, any> | nil
--- @return string
function Locale:t(key, subs)
    local phrase, result
    subs = subs or {}

    -- See if the passed key resolves to a valid phrase string
    if type(self.phrases[key]) == 'string' then
        phrase = self.phrases[key]
        -- At this point we know whether the phrase does not exist for this key
    else
        if self.warnOnMissing then
            print(('^3Warning: Missing phrase for key: "%s"'):format(key))
        end
        if self.fallback then
            return self.fallback:t(key, subs)
        end
        result = key
    end

    if type(phrase) == 'string' then
        result = translateKey(phrase, subs)
    end

    return result
end

--- Check if a phrase key has already been defined within the Locale instance phrase maps.
--- @return boolean
function Locale:has(key)
    return self.phrases[key] ~= nil
end

--- Will remove phrase keys from a Locale instance, using recursion/
--- @param phraseTarget string | table
--- @param prefix string
function Locale:delete(phraseTarget, prefix)
    -- If the target is a string, we know that this is the end
    -- of nested table tree.
    if type(phraseTarget) == 'string' then
        self.phrases[phraseTarget] = nil
    else
        for key, phrase in pairs(phraseTarget) do
            local prefixKey = prefix and ('%s.%s'):format(prefix, key) or key

            if type(phrase) == 'table' then
                self:delete(phrase, prefixKey)
            else
                self.phrases[prefixKey] = nil
            end
        end
    end
end
