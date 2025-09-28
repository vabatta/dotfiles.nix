{ ... }:
[
  # SECTION: Files
  {
    key = "<leader>fe";
    mode = "n";
    desc = "Explore files";
    action = "<cmd>lua MiniFiles.open()<CR>";
  }

  {
    key = "<leader>ff";
    mode = "n";
    desc = "Find file";
    action = "<cmd>Pick files<CR>";
  }

  {
    key = "<leader>fn";
    mode = "n";
    desc = "New file";
    lua = true;
    action = ''
      function()
        vim.ui.input({ prompt = "Filename" }, function(filename)
          if filename and #filename > 0 then
            vim.cmd("edit " .. filename)
          end
        end)
      end
    '';
  }

  {
    key = "<leader>fs";
    mode = "n";
    desc = "Save file as";
    lua = true;
    action = ''
      function()
        vim.ui.input({ prompt = "Filename" }, function(filename)
          if filename and #filename > 0 then
            vim.cmd("saveas " .. filename)
          end
        end)
      end
    '';
  }

  # SECTION: Buffers
  {
    key = "<leader>bh";
    mode = "n";
    desc = "Hide buffer";
    action = "<cmd>lua MiniBufremove.unshow()<CR>";
  }

  {
    key = "<leader>bd";
    mode = "n";
    desc = "Close buffer";
    action = "<cmd>lua MiniBufremove.delete()<CR>";
  }

  {
    key = "<leader>bw";
    mode = "n";
    desc = "Wipe buffer";
    action = "<cmd>lua MiniBufremove.wipeout()<CR>";
  }

  {
    key = "<leader>bn";
    mode = "n";
    desc = "New buffer";
    action = "<cmd>enew<CR>";
  }

  {
    key = "<leader>bf";
    mode = "n";
    desc = "Find buffer";
    action = "<cmd>Pick buffers<CR>";
  }

  # SECTION: Windows
  {
    key = "<leader>wh";
    mode = "n";
    desc = "Split window horizontally";
    action = "<cmd>split<CR>";
  }

  {
    key = "<leader>wv";
    mode = "n";
    desc = "Split window vertically";
    action = "<cmd>vsplit<CR>";
  }
]
