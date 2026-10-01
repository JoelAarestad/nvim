-- GitHub Copilot. Needs Node.js 22 or newer. Run :Copilot setup once to sign in.
-- Accept a suggestion with <Tab>; see :help copilot for more keys.
return {
    "github/copilot.vim",
    event = "InsertEnter", -- start Copilot (a Node.js process) only once you start typing
    cmd = "Copilot",
}
