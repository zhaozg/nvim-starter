# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## 个性性

本模块已 LazyVim 为基础，提高 `workspace` 或 `project` 的扩展能力.
其基本思路为需要灵活配置的插件通过 `.neconf.json` 进行自定义参数配置。

关键模块列表:

- neoconf.nvim
- Overseer.nvim
- none-ls.nvim
- codecompanion.nvim

## 配置示例

### none-ls.nvim

``` .neoconf.json
{
  "null-ls": {
    "sources" : {
      -- Look lspconfig manual
      "none-ls.formatting.gindent": {
        "extra_filetypes": [ "c" ]
      }
    },
    "format": [ "c" ]
  }
}
```

- `null-ls.sources`: Contains all source for null-ls.
- `null-ls.format`: Export `Format` command format `c` file.

