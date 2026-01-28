-- colors/lake-dweller.lua
-- Minimal, soft theme with actual color names + float, git-commit, oil.nvim, and cmp.nvim integrations

local C = {
    light_grey  = "#d8d8d8", -- base text
    rosy_pink   = "#d58ca6", -- strings
    soft_green  = "#96ca96", -- comments
    muted_slate = "#858d95", -- keywords
    bright_red  = "#ef8a90", -- constants & errors
    pale_blue   = "#adc7e6", -- functions
    muted_cyan  = "#8abbb4", -- types / namespaces
    dark_navy   = "#11161c", -- main background

    -- Panels / extras (all named by color, not usage)
    dark_teal   = "#122932", -- float/menu panels
    steel_grey  = "#5a6475", -- dim grey
    ash_grey    = "#3c4455", -- border grey
    deep_blue   = "#252f3d", -- selection blue
    dusk_blue   = "#33415c", -- search blue
    sand_yellow = "#d1b77a", -- warn yellow
    aqua_teal   = "#5fa6a6", -- hint teal
}

local NONE = "NONE"
vim.o.termguicolors = true
local function hi(group, opts) vim.api.nvim_set_hl(0, group, opts) end

---------------------------------------------------------------------
-- Base UI
---------------------------------------------------------------------
hi("Normal", { fg = C.light_grey, bg = C.dark_navy })
hi("NormalNC", { fg = C.light_grey, bg = C.dark_navy })
hi("SignColumn", { fg = C.light_grey, bg = C.dark_navy })
hi("LineNr", { fg = C.steel_grey, bg = C.dark_navy })
hi("CursorLineNr", { fg = C.light_grey, bg = C.dark_navy })
hi("WinSeparator", { fg = C.ash_grey, bg = C.dark_navy })
hi("Visual", { fg = C.light_grey, bg = C.dusk_blue })

hi("Search", { fg = C.light_grey, bg = C.dark_teal, bold = true })     -- all matches
hi("IncSearch", { fg = C.dark_navy, bg = C.sand_yellow, bold = true }) -- typing phase
hi("CurSearch", { fg = C.dark_navy, bg = C.aqua_teal, bold = true })   -- current match

hi("MatchPatern", { fg = C.bright_red, bg = C.NONE, underline = true })

hi("QuickFixLine", { fg = C.dark_navy, bg = C.sand_yellow })

-- Floating windows & menus (contrasted panel)
hi("NormalFloat", { fg = C.light_grey, bg = C.dark_teal })
hi("Special", { fg = C.light_grey, bg = C.dark_teal })
hi("FloatBorder", { fg = C.muted_slate, bg = C.dark_teal })
hi("FloatTitle", { fg = C.light_grey, bg = C.dark_teal, bold = true })

hi("Pmenu", { fg = C.light_grey, bg = C.dark_teal })
hi("PmenuSel", { fg = C.dark_navy, bg = C.muted_cyan, bold = true })
hi("PmenuSbar", { fg = C.light_grey, bg = C.dark_teal })
hi("PmenuThumb", { fg = C.light_grey, bg = C.dark_teal })

hi("StatusLine", { fg = C.light_grey, bg = C.dark_teal })
hi("StatusLineNC", { fg = C.steel_grey, bg = C.dark_teal })

---------------------------------------------------------------------
-- Comments
---------------------------------------------------------------------
hi("@comment", { fg = C.soft_green, bg = NONE, italic = true })
hi("Comment", { fg = C.soft_green, bg = NONE, italic = true })

---------------------------------------------------------------------
-- Keywords (grey)
---------------------------------------------------------------------
hi("@keyword", { fg = C.muted_slate, bg = NONE })
hi("@keyword.function", { fg = C.muted_slate, bg = NONE })
hi("@keyword.return", { fg = C.muted_slate, bg = NONE })
hi("@conditional", { fg = C.muted_slate, bg = NONE })
hi("@repeat", { fg = C.muted_slate, bg = NONE })
hi("Keyword", { fg = C.muted_slate, bg = NONE })
hi("Statement", { fg = C.muted_slate, bg = NONE })
-- Operators stay neutral
hi("@operator", { fg = C.light_grey, bg = NONE })

---------------------------------------------------------------------
-- Functions (pale blue)
---------------------------------------------------------------------
hi("@function", { fg = C.pale_blue, bg = NONE })
hi("@method", { fg = C.pale_blue, bg = NONE })
hi("@function.call", { fg = C.pale_blue, bg = NONE })
hi("@method.call", { fg = C.pale_blue, bg = NONE })
hi("@constructor", { fg = C.pale_blue, bg = NONE })
hi("@function.builtin", { fg = C.pale_blue, bg = NONE })

---------------------------------------------------------------------
-- Variables / Members / Properties (white)
---------------------------------------------------------------------
hi("@variable", { fg = C.light_grey, bg = NONE })
hi("@variable.parameter", { fg = C.light_grey, bg = NONE })
hi("@variable.member", { fg = C.light_grey, bg = NONE })
hi("@field", { fg = C.light_grey, bg = NONE })
hi("@property", { fg = C.light_grey, bg = NONE })

---------------------------------------------------------------------
-- Types (muted cyan)
---------------------------------------------------------------------
hi("@type", { fg = C.muted_cyan, bg = NONE })
hi("@type.builtin", { fg = C.muted_cyan, bg = NONE })
hi("@namespace", { fg = C.muted_cyan, bg = NONE })

---------------------------------------------------------------------
-- Modules / Imports (white)
---------------------------------------------------------------------
hi("@namespace.import", { fg = C.light_grey, bg = NONE })
hi("@module", { fg = C.light_grey, bg = NONE })

---------------------------------------------------------------------
-- Strings (rosy pink)
---------------------------------------------------------------------
hi("@string", { fg = C.rosy_pink, bg = NONE })
hi("@string.special", { fg = C.rosy_pink, bg = NONE })
hi("@character", { fg = C.rosy_pink, bg = NONE })

---------------------------------------------------------------------
-- Constants (bright red family)
---------------------------------------------------------------------
hi("@boolean", { fg = C.bright_red, bg = NONE })
hi("@number", { fg = C.bright_red, bg = NONE })
hi("@constant", { fg = C.bright_red, bg = NONE })
hi("@constant.builtin", { fg = C.bright_red, bg = NONE })
hi("@symbol", { fg = C.bright_red, bg = NONE })

---------------------------------------------------------------------
-- Diagnostics
---------------------------------------------------------------------
hi("DiagnosticError", { fg = C.bright_red, bg = NONE })
hi("DiagnosticWarn", { fg = C.sand_yellow, bg = NONE })
hi("DiagnosticHint", { fg = C.aqua_teal, bg = NONE })
hi("DiagnosticInfo", { fg = C.light_grey, bg = NONE })

hi("DiagnosticVirtualTextError", { fg = C.bright_red })
hi("DiagnosticVirtualTextWarn", { fg = C.sand_yellow })
hi("DiagnosticVirtualTextHint", { fg = C.aqua_teal })
hi("DiagnosticVirtualTextInfo", { fg = C.light_grey })

hi("DiagnosticUnderlineError", { undercurl = true, sp = C.bright_red })
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = C.sand_yellow })
hi("DiagnosticUnderlineHint", { undercurl = true, sp = C.aqua_teal })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = C.light_grey })

hi("DiagnosticUnnecessary", { fg = C.steel_grey})


---------------------------------------------------------------------
-- Fallbacks
---------------------------------------------------------------------
for _, g in ipairs({ "@punctuation", "@constant.macro", "@attribute" }) do
    hi(g, { fg = C.light_grey, bg = NONE })
end

---------------------------------------------------------------------
-- LSP semantic tokens
---------------------------------------------------------------------
hi("@lsp.type.variable", { link = "@variable" })
hi("@lsp.type.parameter", { link = "@variable.parameter" })
hi("@lsp.type.property", { link = "@property" })
hi("@lsp.type.field", { link = "@field" })
hi("@lsp.type.function", { link = "@function" })
hi("@lsp.type.method", { link = "@method.call" })
hi("@lsp.typemod.function.defaultLibrary", { link = "@function.builtin" })
hi("@lsp.typemod.variable.readonly", { link = "@constant" })

---------------------------------------------------------------------
-- Git: commit message buffer fixes
---------------------------------------------------------------------
hi("gitcommitSummary", { fg = C.light_grey, bg = NONE, bold = true })
hi("gitcommitOverflow", { fg = C.bright_red, bg = NONE, bold = true }) -- >50 chars

hi("gitcommitComment", { fg = C.soft_green, bg = NONE, italic = true })
hi("gitcommitHeader", { fg = C.muted_slate, bg = NONE, bold = true })

hi("gitcommitOnBranch", { fg = C.muted_slate, bg = NONE })
hi("gitcommitBranch", { fg = C.muted_cyan, bg = NONE, bold = true })
hi("gitcommitNoBranch", { fg = C.muted_slate, bg = NONE })
hi("gitcommitUnmerged", { fg = C.bright_red, bg = NONE, bold = true })

hi("gitcommitUntracked", { fg = C.muted_slate, bg = NONE })
hi("gitcommitDiscarded", { fg = C.bright_red, bg = NONE })
hi("gitcommitSelected", { fg = C.pale_blue, bg = NONE })
hi("gitcommitDiscardedType", { fg = C.bright_red, bg = NONE })
hi("gitcommitSelectedType", { fg = C.pale_blue, bg = NONE })
hi("gitcommitDiscardedFile", { fg = C.bright_red, bg = NONE })
hi("gitcommitSelectedFile", { fg = C.pale_blue, bg = NONE })
hi("gitcommitFile", { fg = C.light_grey, bg = NONE })

hi("gitcommitTrailerToken", { fg = C.muted_slate, bg = NONE, bold = true })
hi("gitcommitTrailerValue", { fg = C.rosy_pink, bg = NONE })

-- Optional diff colors (for patch/diff views)
hi("DiffAdd", { fg = C.soft_green, bg = NONE })
hi("DiffChange", { fg = C.pale_blue, bg = NONE })
hi("DiffDelete", { fg = C.bright_red, bg = NONE })
hi("DiffText", { fg = C.muted_slate, bg = NONE, underline = true })

---------------------------------------------------------------------
-- Oil.nvim (buffered file explorer)
---------------------------------------------------------------------
hi("OilFile", { fg = C.light_grey, bg = NONE })
hi("OilDir", { fg = C.muted_cyan, bg = NONE, bold = true })       -- folders
hi("OilSymlink", { fg = C.pale_blue, bg = NONE, italic = true })  -- symlinks
hi("OilHidden", { fg = C.muted_slate, bg = NONE, italic = true }) -- dotfiles
hi("OilHeader", { fg = C.muted_slate, bg = NONE, bold = true })   -- path header

hi("OilBorder", { fg = C.muted_slate, bg = NONE })
hi("OilWinBar", { fg = C.muted_slate, bg = NONE })
hi("OilIndent", { fg = C.muted_slate, bg = NONE })               -- tree guides
hi("OilExpander", { fg = C.muted_slate, bg = NONE })             -- arrows
hi("OilColumns", { fg = C.muted_slate, bg = NONE })              -- size/mtime

hi("OilModified", { fg = C.bright_red, bg = NONE, bold = true }) -- changed
hi("OilDeleted", { fg = C.bright_red, bg = NONE })               -- removed
hi("OilAdded", { fg = C.soft_green, bg = NONE })                 -- new
hi("OilWarning", { fg = C.sand_yellow, bg = NONE })
hi("OilError", { fg = C.bright_red, bg = NONE })

hi("OilSelected", { fg = C.light_grey, bg = NONE, underline = true })
hi("OilCursorLine", { fg = C.light_grey, bg = NONE, underline = true })

pcall(vim.api.nvim_set_hl, 0, "OilDirectory", { link = "OilDir" })
pcall(vim.api.nvim_set_hl, 0, "OilLink", { link = "OilSymlink" })

---------------------------------------------------------------------
-- nvim-cmp (completion) — full support
---------------------------------------------------------------------
hi("CmpItemAbbr", { fg = C.light_grey, bg = NONE })
hi("CmpItemAbbrDeprecated", { fg = C.muted_slate, bg = NONE, strikethrough = true })
hi("CmpItemAbbrMatch", { fg = C.muted_slate, bg = NONE, bold = true })
hi("CmpItemAbbrMatchFuzzy", { fg = C.muted_slate, bg = NONE })
hi("CmpItemMenu", { fg = C.muted_slate, bg = NONE, italic = true })

hi("CmpItemKind", { fg = C.light_grey, bg = NONE })
hi("CmpItemKindFunction", { fg = C.pale_blue, bg = NONE })
hi("CmpItemKindMethod", { fg = C.pale_blue, bg = NONE })
hi("CmpItemKindConstructor", { fg = C.pale_blue, bg = NONE })

hi("CmpItemKindClass", { fg = C.muted_cyan, bg = NONE })
hi("CmpItemKindStruct", { fg = C.muted_cyan, bg = NONE })
hi("CmpItemKindInterface", { fg = C.muted_cyan, bg = NONE })
hi("CmpItemKindTypeParameter", { fg = C.muted_cyan, bg = NONE })
hi("CmpItemKindModule", { fg = C.muted_cyan, bg = NONE })
hi("CmpItemKindNamespace", { fg = C.muted_cyan, bg = NONE })

hi("CmpItemKindVariable", { fg = C.light_grey, bg = NONE })
hi("CmpItemKindProperty", { fg = C.light_grey, bg = NONE })
hi("CmpItemKindField", { fg = C.light_grey, bg = NONE })

hi("CmpItemKindConstant", { fg = C.bright_red, bg = NONE })
hi("CmpItemKindEnum", { fg = C.bright_red, bg = NONE })
hi("CmpItemKindEnumMember", { fg = C.bright_red, bg = NONE })

hi("CmpItemKindKeyword", { fg = C.muted_slate, bg = NONE })

hi("CmpItemKindText", { fg = C.rosy_pink, bg = NONE })
hi("CmpItemKindString", { fg = C.rosy_pink, bg = NONE })
hi("CmpItemKindColor", { fg = C.rosy_pink, bg = NONE })

hi("CmpItemKindSnippet", { fg = C.soft_green, bg = NONE })

hi("CmpItemKindFile", { fg = C.light_grey, bg = NONE })
hi("CmpItemKindFolder", { fg = C.light_grey, bg = NONE })
hi("CmpItemKindReference", { fg = C.light_grey, bg = NONE })
hi("CmpItemKindUnit", { fg = C.light_grey, bg = NONE })
hi("CmpItemKindValue", { fg = C.light_grey, bg = NONE })

---------------------------------------------------------------------
-- Trouble.nvim
---------------------------------------------------------------------

-- Core panel bg (use dark_navy like Normal)
hi("TroubleNormal", { fg = C.light_grey, bg = C.dark_navy })
hi("TroubleNormalNC", { fg = C.steel_grey, bg = C.dark_navy })
hi("TroubleText", { fg = C.light_grey, bg = C.dark_navy })

-- Indent guides & counts
hi("TroubleIndent", { fg = C.ash_grey, bg = C.dark_navy })
hi("TroubleCount", { fg = C.light_grey, bg = C.deep_blue, bold = true })
hi("TroublePreview", { fg = C.light_grey, bg = C.deep_blue })

-- Meta / file info
hi("Directory", { fg = C.muted_cyan, bg = C.dark_navy, bold = true })
hi("TroubleDiagnosticsItemSource", { fg = C.muted_slate, bg = C.dark_navy, italic = true })
hi("TroubleCode", { fg = C.steel_grey, bg = C.dark_navy })
hi("TroubleIconDirectory", { fg = C.steel_grey, bg = C.dark_navy })
hi("TroubleIconEvent", { fg = C.steel_grey, bg = C.dark_navy })

-- Severity (link to diagnostics so colors stay consistent)
hi("TroubleError", { link = "DiagnosticError" })
hi("TroubleWarning", { link = "DiagnosticWarn" })
hi("TroubleInformation", { link = "DiagnosticInfo" })
hi("TroubleHint", { link = "DiagnosticHint" })

---------------------------------------------------------------------
-- Telescope.nvim — all layouts (horizontal/vertical/ivy/cursor, split/float)
---------------------------------------------------------------------
hi("TelescopeNormal", { fg = C.light_grey, bg = C.dark_navy })
hi("TelescopeBorder", { fg = C.ash_grey, bg = C.dark_navy })
hi("TelescopeTitle", { fg = C.light_grey, bg = C.dark_navy, bold = true })

-- Results
hi("TelescopeResultsNormal", { fg = C.light_grey, bg = C.dark_navy })
hi("TelescopeResultsBorder", { fg = C.ash_grey, bg = C.dark_navy })
hi("TelescopeResultsTitle", { fg = C.light_grey, bg = C.dark_navy, bold = true })
hi("TelescopeSelection", { fg = C.light_grey, bg = C.deep_blue })
hi("TelescopeMultiSelection", { fg = C.pale_blue, bg = C.deep_blue, bold = true })
hi("TelescopeSelectionCaret", { fg = C.muted_slate, bg = C.deep_blue })
hi("TelescopeMatching", { fg = C.muted_slate, bg = C.dark_navy, bold = true })

-- Prompt
hi("TelescopePromptNormal", { fg = C.light_grey, bg = C.dark_navy })
hi("TelescopePromptBorder", { fg = C.ash_grey, bg = C.dark_navy })
hi("TelescopePromptTitle", { fg = C.light_grey, bg = C.dark_navy, bold = true })
hi("TelescopePromptPrefix", { fg = C.muted_slate, bg = C.dark_navy })
hi("TelescopePromptCounter", { fg = C.muted_slate, bg = C.dark_navy })

-- Preview
hi("TelescopePreviewNormal", { fg = C.light_grey, bg = C.dark_navy })
hi("TelescopePreviewBorder", { fg = C.ash_grey, bg = C.dark_navy })
hi("TelescopePreviewTitle", { fg = C.light_grey, bg = C.dark_navy, bold = true })
hi("TelescopePreviewLine", { fg = C.light_grey, bg = C.deep_blue })
hi("TelescopePreviewMatch", { fg = C.muted_slate, bg = C.dark_navy, underline = true })

-- Diff/meta
hi("TelescopeResultsDiffAdd", { fg = C.soft_green, bg = C.dark_navy })
hi("TelescopeResultsDiffChange", { fg = C.pale_blue, bg = C.dark_navy })
hi("TelescopeResultsDiffDelete", { fg = C.bright_red, bg = C.dark_navy })

---------------------------------------------------------------------
-- fzf-lua — all layouts (builtin/term/floating, split, tabs, preview on/off)
---------------------------------------------------------------------
hi("FzfLuaNormal", { fg = C.light_grey, bg = C.dark_navy })
hi("FzfLuaBorder", { fg = C.ash_grey, bg = C.dark_navy })
hi("FzfLuaTitle", { fg = C.light_grey, bg = C.dark_navy, bold = true })

-- Prompt & info
hi("FzfLuaPrompt", { fg = C.muted_slate, bg = C.dark_navy })
hi("FzfLuaInfo", { fg = C.muted_slate, bg = C.dark_navy, italic = true })
hi("FzfLuaPath", { fg = C.muted_cyan, bg = C.dark_navy })
hi("FzfLuaHeaderBind", { fg = C.muted_slate, bg = C.dark_navy })
hi("FzfLuaHeaderText", { fg = C.muted_slate, bg = C.dark_navy })

-- Selection / cursor
hi("FzfLuaCursor", { fg = C.dark_navy, bg = C.light_grey })
hi("FzfLuaCursorLine", { fg = C.light_grey, bg = C.deep_blue })
hi("FzfLuaCursorLineNr", { fg = C.steel_grey, bg = C.deep_blue })

-- Matches / search / markers
hi("FzfLuaMatch", { fg = C.muted_slate, bg = C.dark_navy, bold = true })
hi("FzfLuaSearch", { fg = C.light_grey, bg = C.dusk_blue })
hi("FzfLuaMarker", { fg = C.pale_blue, bg = C.dark_navy, bold = true })

-- Preview
hi("FzfLuaPreviewNormal", { fg = C.light_grey, bg = C.dark_navy })
hi("FzfLuaPreviewBorder", { fg = C.ash_grey, bg = C.dark_navy })
hi("FzfLuaPreviewTitle", { fg = C.light_grey, bg = C.dark_navy, bold = true })
hi("FzfLuaPreviewLine", { fg = C.light_grey, bg = C.deep_blue })
hi("FzfLuaPreviewSearch", { fg = C.light_grey, bg = C.dusk_blue })
hi("FzfLuaPreviewMatch", { fg = C.muted_slate, bg = C.dark_navy, underline = true })

---------------------------------------------------------------------
-- which-key.nvim
---------------------------------------------------------------------
hi("WhichKey", { fg = C.pale_blue, bg = C.dark_navy })
hi("WhichKeyGroup", { fg = C.muted_cyan, bg = C.dark_navy, bold = true })
hi("WhichKeyDesc", { fg = C.light_grey, bg = C.dark_navy })
hi("WhichKeySeperator", { fg = C.steel_grey, bg = C.dark_navy })
hi("WhichKeySeparator", { fg = C.steel_grey, bg = C.dark_navy })
hi("WhichKeyFloat", { fg = C.light_grey, bg = C.dark_navy })
hi("WhichKeyBorder", { fg = C.ash_grey, bg = C.dark_navy })
hi("WhichKeyValue", { fg = C.muted_slate, bg = C.dark_navy })
hi("WhichKeyNormal", { fg = C.light_grey, bg = C.dark_navy })
hi("WhichKeyTitle", { fg = C.light_grey, bg = C.dark_navy, bold = true })

---------------------------------------------------------------------
-- Snacks.nvim (picker, etc.)
---------------------------------------------------------------------
hi("SnacksPickerNormal", { fg = C.light_grey, bg = C.dark_navy })
hi("SnacksPickerBorder", { fg = C.ash_grey, bg = C.dark_navy })
hi("SnacksPickerTitle", { fg = C.light_grey, bg = C.dark_navy, bold = true })

hi("SnacksPickerPrompt", { fg = C.muted_slate, bg = C.dark_navy })
hi("SnacksPickerInput", { fg = C.light_grey, bg = C.dark_navy })
hi("SnacksPickerInputBorder", { fg = C.ash_grey, bg = C.dark_navy })
hi("SnacksPickerInputTitle", { fg = C.light_grey, bg = C.dark_navy, bold = true })

hi("SnacksPickerList", { fg = C.light_grey, bg = C.dark_navy })
hi("SnacksPickerListBorder", { fg = C.ash_grey, bg = C.dark_navy })
hi("SnacksPickerListTitle", { fg = C.light_grey, bg = C.dark_navy, bold = true })
hi("SnacksPickerListCursorLine", { fg = C.light_grey, bg = C.deep_blue })

hi("SnacksPickerPreview", { fg = C.light_grey, bg = C.dark_navy })
hi("SnacksPickerPreviewBorder", { fg = C.ash_grey, bg = C.dark_navy })
hi("SnacksPickerPreviewTitle", { fg = C.light_grey, bg = C.dark_navy, bold = true })
hi("SnacksPickerPreviewLine", { fg = C.light_grey, bg = C.deep_blue })

hi("SnacksPickerMatch", { fg = C.muted_slate, bg = C.dark_navy, bold = true })
hi("SnacksPickerDir", { fg = C.muted_cyan, bg = C.dark_navy })
hi("SnacksPickerFile", { fg = C.light_grey, bg = C.dark_navy })
hi("SnacksPickerSelected", { fg = C.pale_blue, bg = C.deep_blue, bold = true })
hi("SnacksPickerIdx", { fg = C.steel_grey, bg = C.dark_navy })
hi("SnacksPickerRow", { fg = C.steel_grey, bg = C.dark_navy })
hi("SnacksPickerCol", { fg = C.steel_grey, bg = C.dark_navy })
hi("SnacksPickerComment", { fg = C.soft_green, bg = C.dark_navy, italic = true })
hi("SnacksPickerLabel", { fg = C.sand_yellow, bg = C.dark_navy, bold = true })

---------------------------------------------------------------------
-- noice.nvim — navy background, subtle borders, diag-linked severities
---------------------------------------------------------------------
---- Generic popups/splits
--hi("NoicePopup", { fg = C.light_grey, bg = C.dark_teal })
--hi("NoicePopupBorder", { fg = C.ash_grey, bg = C.dark_teal })
--hi("NoiceSplit", { fg = C.light_grey, bg = C.dark_navy })
--
---- Confirm dialogs
--hi("NoiceConfirm", { fg = C.light_grey, bg = C.dark_navy })
--hi("NoiceConfirmBorder", { fg = C.ash_grey, bg = C.dark_navy })
--
---- Cmdline popup (":" search/replace inputs, Lua cmdline, etc.)
--hi("NoiceCmdlinePopup", { fg = C.light_grey, bg = C.dark_navy })
--hi("NoiceCmdlinePopupBorder", { fg = C.light_grey, bg = C.dark_navy })
--hi("NoiceCmdlineIcon", { fg = C.muted_slate, bg = C.dark_navy })
--hi("NoiceCmdlinePrompt", { fg = C.light_grey, bg = C.dark_navy })
--hi("NoiceCmdlinePopupTitle", { fg = C.light_grey, bg = C.dark_navy, bold = true })
--
---- Popupmenu (Noice’s own menu; keep aligned with your Pmenu or navy)
---- If you prefer it like your Pmenu, link these to Pmenu/PmenuSel instead.
--hi("NoicePopupmenu", { fg = C.light_grey, bg = C.dark_navy })
--hi("NoicePopupmenuBorder", { fg = C.light_grey, bg = C.dark_navy })
--hi("NoicePopupmenuSelected", { fg = C.light_grey, bg = C.deep_blue, bold = true })
--hi("NoicePopupmenuMatch", { fg = C.muted_slate, bg = C.dark_navy, bold = true })
--
---- Messages / virtual text (route through your Diagnostics palette)
--hi("NoiceVirtualTextError", { link = "DiagnosticVirtualTextError" })
--hi("NoiceVirtualTextWarn", { link = "DiagnosticVirtualTextWarn" })
--hi("NoiceVirtualTextInfo", { link = "DiagnosticVirtualTextInfo" })
--hi("NoiceVirtualTextHint", { link = "DiagnosticVirtualTextHint" })
--
---- LSP progress line (spinner/title/client)
--hi("NoiceLspProgressTitle", { fg = C.light_grey, bg = C.dark_navy, bold = true })
--hi("NoiceLspProgressClient", { fg = C.muted_cyan, bg = C.dark_navy })
--hi("NoiceLspProgressSpinner", { fg = C.pale_blue, bg = C.dark_navy, bold = true })
--hi("NoiceLspProgressDone", { fg = C.soft_green, bg = C.dark_navy })
--
---- Levels (map to your diagnostics)
--hi("NoiceError", { link = "DiagnosticError" })
--hi("NoiceWarn", { link = "DiagnosticWarn" })
--hi("NoiceInfo", { link = "DiagnosticInfo" })
--hi("NoiceHint", { link = "DiagnosticHint" })
--
---- Optional: make regular msg area consistent too
--hi("MsgArea", { fg = C.light_grey, bg = C.dark_navy })
--hi("MsgSeparator", { fg = C.ash_grey, bg = C.dark_navy })
--
---- flash.nvim (if installed) — replaces hlsearch visuals
--hi("FlashMatch",   { fg = C.dark_navy, bg = C.pale_blue,  bold = true })
--hi("FlashCurrent", { fg = C.dark_navy, bg = C.rosy_pink,  bold = true })
--hi("FlashLabel",   { fg = C.dark_navy, bg = C.sand_yellow, bold = true })
--
---- nvim-hlslens (if installed) — lens/count overlays
--hi("HlSearchLens",     { fg = C.muted_slate, bg = C.dark_navy, italic = true })
--hi("HlSearchLensNear", { fg = C.light_grey,  bg = C.dusk_blue, bold = true })


vim.g.colors_name = "lake-dweller"
