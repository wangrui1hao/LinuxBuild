if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:python3_host_prog = exepath('python3')

call plug#begin('~/.config/nvim/plugged')
Plug 'Yggdroot/LeaderF',{'do': './install.sh'}
Plug 'morhetz/gruvbox'
Plug 'Shougo/defx.nvim'
Plug 'fatih/vim-go'
"coc.vim yyds !!!!
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
"hight light
Plug 'sheerun/vim-polyglot'

call plug#end()

source ~/.config/nvim/setting/custom.vim
source ~/.config/nvim/setting/leaderf.vim
source ~/.config/nvim/setting/defx.vim
source ~/.config/nvim/setting/cocconf.vim
source ~/.config/nvim/setting/gtags.vim
source ~/.config/nvim/setting/gtags-cscope.vim
source ~/.config/nvim/setting/DoxygenToolkit.vim
