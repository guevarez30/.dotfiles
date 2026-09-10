{ pkgs, ... }:
let
  # Select individual files, so the VM never loads the legacy Lazy/Mason bootstrap.
  shared = file: "dofile(${builtins.toJSON "${file}"})\n";
  plugin = module: file:
    "configurePlugin(${builtins.toJSON module}, dofile(${builtins.toJSON "${file}"}))\n";
in {
  xdg.configFile."nvim/lua/main/branch_review.lua".source = ../nvim-config/.config/nvim/lua/main/branch_review.lua;
  xdg.configFile."nvim/lua/main/clanker.lua".source = ../nvim-config/.config/nvim/lua/main/clanker.lua;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
    extraPackages = import ./packages.nix { inherit pkgs; };
    plugins = with pkgs.vimPlugins; [
      plenary-nvim nvim-web-devicons dracula-nvim lualine-nvim
      grapple-nvim telescope-nvim telescope-fzf-native-nvim
      nvim-cmp cmp-nvim-lsp cmp-buffer cmp-path cmp_luasnip luasnip lspkind-nvim
      nvim-autopairs nvim-lspconfig conform-nvim
      vim-vinegar vim-surround vim-fugitive gitsigns-nvim vim-tmux-navigator
      vim-dadbod vim-dadbod-ui vim-dadbod-completion
      (nvim-treesitter.withPlugins (p: with p; [
        bash c css go gomod gosum gotmpl helm html java javascript json lua
        markdown markdown_inline nix python rust tsx typescript vim vimdoc yaml
      ]))
      nvim-treesitter-context
    ];
    initLua = builtins.readFile ./editor.lua
      + shared ../nvim-config/.config/nvim/lua/main/set.lua
      + shared ../nvim-config/.config/nvim/lua/main/maps.lua
      + plugin "dracula" ../nvim-config/.config/nvim/lua/plugins/colorscheme.lua
      + shared ../nvim-config/.config/nvim/lua/main/highlights.lua
      + plugin "telescope" ../nvim-config/.config/nvim/lua/plugins/telescope.lua
      + plugin "lualine" ../nvim-config/.config/nvim/lua/plugins/lualine.lua
      + plugin "conform" ../nvim-config/.config/nvim/lua/plugins/conform.lua
      + plugin "dadbod" ../nvim-config/.config/nvim/lua/plugins/dadbod.lua
      + plugin "gitsigns" ../nvim-config/.config/nvim/lua/plugins/gitsigns.lua
      + plugin "grapple" ../nvim-config/.config/nvim/lua/plugins/grapple.lua
      + plugin "fugitive" ../nvim-config/.config/nvim/lua/plugins/fugitive.lua
      + shared ../nvim-config/.config/nvim/lua/main/autocmds.lua
      + "require('main.branch_review').setup()\n";
  };
}
