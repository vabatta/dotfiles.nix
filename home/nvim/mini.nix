{ ... }:
{
  # text editing
  ai.enable = true;
  align.enable = true;
  comment.enable = true;
  completion.enable = true;
  # keymap.enable = true;
  move.enable = true;
  operators.enable = true;
  pairs.enable = true;
  snippets.enable = true;
  splitjoin.enable = true;
  surround.enable = true;

  # workflow
  basics.enable = true;
  basics.setupOpts = {
    options = {
      extra_ui = true;
    };
  };
  bracketed.enable = true;
  bufremove.enable = true;
  clue.enable = true;
  clue.setupOpts = {
    triggers = [
      # Leader triggers
      {
        mode = "n";
        keys = "<Leader>";
      }
      {
        mode = "x";
        keys = "<Leader>";
      }

      # Built-in completion
      {
        mode = "i";
        keys = "<C-x>";
      }

      # `g` key
      {
        mode = "n";
        keys = "g";
      }
      {
        mode = "x";
        keys = "g";
      }

      # Marks
      {
        mode = "n";
        keys = "'";
      }
      {
        mode = "n";
        keys = "`";
      }
      {
        mode = "x";
        keys = "'";
      }
      {
        mode = "x";
        keys = "`";
      }

      # Registers
      {
        mode = "n";
        keys = "\"";
      }
      {
        mode = "x";
        keys = "\"";
      }
      {
        mode = "i";
        keys = "<C-r>";
      }
      {
        mode = "c";
        keys = "<C-r>";
      }

      # Window commands
      {
        mode = "n";
        keys = "<C-w>";
      }

      # `z` key
      {
        mode = "n";
        keys = "z";
      }
      {
        mode = "x";
        keys = "z";
      }
    ];

    clues = [
      # Enhance this by adding descriptions for <Leader> mapping groups
      "miniclue.gen_clues.builtin_completion()"
      "miniclue.gen_clues.g()"
      "miniclue.gen_clues.marks()"
      "miniclue.gen_clues.registers()"
      "miniclue.gen_clues.windows()"
      "miniclue.gen_clues.z()"
    ];
  };
  diff.enable = true;
  diff.setupOpts = {
    view = {
      style = "sign";
    };
  };
  extra.enable = true;
  files.enable = true;
  git.enable = true;
  jump.enable = true;
  jump2d.enable = true;
  misc.enable = true;
  pick.enable = true;
  sessions.enable = true;
  visits.enable = true;

  # appearance
  animate.enable = true;
  # base16.enable = true;
  colors.enable = true;
  cursorword.enable = true;
  hipatterns.enable = true;
  hipatterns.setupOpts = {
    highlighters = {
      fixme = {
        pattern = "%f[%w]()FIXME()%f[%W]";
        group = "MiniHipatternsFixme";
      };
      hack = {
        pattern = "%f[%w]()HACK()%f[%W]";
        group = "MiniHipatternsHack";
      };
      todo = {
        pattern = "%f[%w]()TODO()%f[%W]";
        group = "MiniHipatternsTodo";
      };
      note = {
        pattern = "%f[%w]()NOTE()%f[%W]";
        group = "MiniHipatternsNote";
      };
      review = {
        pattern = "%f[%w]()REVIEW()%f[%W]";
        group = "MiniHipatternsReview";
      };
      section = {
        pattern = "%f[%w]()SECTION()%f[%W]";
        group = "MiniHipatternsSection";
      };

      # Highlight hex color strings (`#rrggbb`) using that color
      hex_color = "hipatterns.gen_highlighter.hex_color()";
    };
  };
  # hues.enable = true;
  icons.enable = true;
  indentscope.enable = true;
  map.enable = true;
  notify.enable = true;
  starter.enable = true;
  statusline.enable = true;
  # tabline.enable = true;
  trailspace.enable = true;
}
