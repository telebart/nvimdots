function GetFilesize()
  local size = vim.fn.getfsize(vim.fn.expand("%"))
  if size <= 0 then
    return ""
  elseif size < 1024 then
    return size .. "B"
  elseif size < 1048576 then
    return ("%.2fkB"):format(size / 1024)
  else
    return ("%.2fMB"):format(size / 1048576)
  end
end
vim.o.statusline = [[%#Delimiter#%f%#Title#%m%r %#NonText#%{luaeval("GetFilesize()")}%=%#Title#%y %#Boolean#%(%l/%L%):%c/%-2{virtcol('$')-1}]]
