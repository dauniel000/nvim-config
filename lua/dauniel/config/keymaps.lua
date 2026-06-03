vim.g.mapleader = " "

vim.keymap.set({ "n", "v" }, "d", '"_d', { desc = "Delete without yanking" })
vim.keymap.set({ "n", "v" }, "dd", '"_dd', { desc = "Delete line without yanking" })

vim.keymap.set({ "n", "v" }, "c", '"_c', { desc = "Change without yanking" })

vim.keymap.set({ "n", "v" }, "x", "d", { desc = "Cut text (Yank and Delete)" })
vim.keymap.set("n", "xx", "dd", { desc = "Cut line (Yank and Delete)" })
