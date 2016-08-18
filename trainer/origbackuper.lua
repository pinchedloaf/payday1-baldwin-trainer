--Only for use in baldwin's small package! If you want to use something similar, try interceptor or __orig_func_name = orig_func_name. Have a conscience already!

Backuper = Backuper or class()

function Backuper:init(class_name)
  self._name = class_name
  self._originals = {}
  self._cached = {}
  self._protected = {}
end


function Backuper:cache(data)
  if not self._cached[data] then
    self._cached[data] = true
  return false
  end
  return true
end

function Backuper:backup(stuff_string,name,forced)
  if not baldwin_config.EnableNormalisation and not forced then
    return
  end
  if self:cache(stuff_string) then
    return self._originals[name] or self._originals[stuff_string]
  end
  
  local execute
  
  if name then
    execute = loadstring(self._name..'._originals[\"'..name..'\"] = '..stuff_string)
  else
    execute = loadstring(self._name..'._originals[\"'..stuff_string..'\"] = '..stuff_string)
  end
  
  pcall(execute)
  
  
  return self._originals[name] or self._originals[stuff_string]
  
end

function Backuper:restore(stuff_string, name, forced)
  if not baldwin_config.EnableNormalisation and not forced then
    return
  end
  local n = self._originals[name] or self._originals[stuff_string]
  if n then
    pcall(loadstring(stuff_string..' = '..self._name..'._originals[\"'..stuff_string..'\"]'))
    self._originals[n] = nil
  self._cached[n] = nil
  end
end

function Backuper:restore_all(forced)
  if not baldwin_config.EnableNormalisation and not forced then
    return
  end
  for n,_ in pairs(self._originals) do
    pcall(loadstring(n..' = '..self._name..'._originals[\"'..n..'\"]'))
  self._originals[n] = nil
  self._cached[n] = nil
  end
end
