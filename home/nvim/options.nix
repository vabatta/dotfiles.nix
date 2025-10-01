{ ... }:
{
  smoothscroll = true;
  clipboard = "unnamed"; # use default register for clipboard (sync with OS)

  scrolloff = 8; # rows of context
  sidescrolloff = 8; # columns of context
  cursorline = true; # highlight row to cursor
  cursorcolumn = true; # highlight column to cursor

  virtualedit = "block"; # allow cursor to move where there is no text in visual block mode
  signcolumn = "yes"; # always show the signcolumn, otherwise it would shift the text each time

  list = true; # show hidden characters
  fillchars = "foldopen:,foldclose:,fold: ,foldsep: ,diff:╱,eob: ";
  listchars = "space:·,tab:→ ,trail:⋅,extends:❯,precedes:❮"; # eol:↵
  showbreak = "↪";

  expandtab = true; # use spaces instead of tabs
  smarttab = true; # tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
  tabstop = 2; # number of spaces tabs count for
  shiftwidth = 2; # size of an indent
  softtabstop = 2; # number of spaces inserted instead of a tab character
  wrap = false; # disable line wrap

  # https://github.com/NotAShelf/nvf/issues/790#issuecomment-2877930088
  formatexpr = "v:lua.require'conform'.formatexpr()"; # use conform for buffer formatting
}
