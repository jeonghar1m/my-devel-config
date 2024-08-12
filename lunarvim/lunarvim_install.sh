brew install neovim
brew install rust
brew install lazygit
LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)

ln -sf ~/my-devel-config/lunarvim/config.lua ~/.config/lvim/config.lua
ln -sf ~/my-devel-config/lunarvim/lazygit.config.yml ~/Library/Application\ Support/lazygit/config.yml
