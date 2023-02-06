return {
  {
    "gbprod/phpactor.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("phpactor").setup({
        install = {
          bin = vim.fn.stdpath("data") .. "/mason/bin/phpactor"
        },
      })
    end
  },

  "StanAngeloff/php.vim",
  "shawncplus/phpcomplete.vim",
  "adoy/vim-php-refactoring-toolbox",

  {
    "tobyS/pdv",
    dependencies = {
      "tobyS/vmustache",
    },
  },

}
