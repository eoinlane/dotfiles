return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        -- nvim-lint pipes the buffer to `markdownlint-cli2 -` over stdin, so the
        -- linter can only resolve its config from cwd (unreliable). Pin our config
        -- from the nvim config dir explicitly so it applies to markdown everywhere.
        ["markdownlint-cli2"] = {
          prepend_args = { "--config", vim.fn.stdpath("config") .. "/.markdownlint.yaml" },
        },
      },
    },
  },
}
