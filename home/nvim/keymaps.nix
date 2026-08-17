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

  # SECTION: Motion — mini.jump2d (hop to a labeled spot on screen)
  {
    key = "s";
    mode = [ "n" "x" "o" ];
    desc = "Hop to labeled spot (mini.jump2d)";
    action = "<cmd>lua MiniJump2d.start()<CR>";
  }

  # SECTION: LSP (fills the empty `<leader>l` group — pair with mini.bracketed's [d / ]d)
  {
    key = "<leader>ld";
    mode = "n";
    desc = "Go to definition";
    action = "<cmd>lua vim.lsp.buf.definition()<CR>";
  }

  {
    key = "<leader>lD";
    mode = "n";
    desc = "Go to declaration";
    action = "<cmd>lua vim.lsp.buf.declaration()<CR>";
  }

  {
    key = "<leader>lr";
    mode = "n";
    desc = "List references";
    action = "<cmd>lua vim.lsp.buf.references()<CR>";
  }

  {
    key = "<leader>li";
    mode = "n";
    desc = "Go to implementation";
    action = "<cmd>lua vim.lsp.buf.implementation()<CR>";
  }

  {
    key = "<leader>la";
    mode = [ "n" "v" ];
    desc = "Code actions";
    action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
  }

  {
    key = "<leader>lh";
    mode = [ "n" "v" ];
    desc = "Hover documentation";
    action = "<cmd>lua vim.lsp.buf.hover()<CR>";
  }

  {
    key = "<leader>lH";
    mode = [ "n" "v" ];
    desc = "Signature help";
    action = "<cmd>lua vim.lsp.buf.signature_help()<CR>";
  }

  {
    key = "<leader>lR";
    mode = "n";
    desc = "Rename symbol";
    action = "<cmd>lua vim.lsp.buf.rename()<CR>";
  }

  # SECTION: Search
  {
    key = "<leader>ss";
    mode = "n";
    desc = "Workspace grep";
    action = "<cmd>Pick grep<CR>";
  }

  {
    key = "<leader>sw";
    mode = "n";
    desc = "Grep word under cursor";
    lua = true;
    action = ''
      function()
        require('mini.pick').builtin.grep({ pattern = vim.fn.expand('<cword>') })
      end
    '';
  }

  # SECTION: Quickfix
  {
    key = "<leader>qq";
    mode = "n";
    desc = "Toggle quickfix window";
    lua = true;
    action = ''
      function()
        local is_open = false
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "quickfix" then
            is_open = true
            break
          end
        end
        if is_open then
          vim.cmd("cclose")
        else
          vim.cmd("copen")
        end
      end
    '';
  }

  # SECTION: Sessions (capital variants are the "persistent" nouns)
  {
    key = "<leader>S";
    mode = "n";
    desc = "Save session";
    action = "<cmd>lua MiniSessions.write({ force = true })<CR>";
  }

  {
    key = "<leader>L";
    mode = "n";
    desc = "Load session";
    action = "<cmd>lua MiniSessions.read()<CR>";
  }
]
