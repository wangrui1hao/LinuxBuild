" 这段设置酌情注释 这个是根据 https://www.v2ex.com/t/561549 配置
" need gtags

" config project root path, only auto gene gtags file while have followed dir
" .git .svn .hg 
let g:Lf_RootMarkers=['.git','.hg','.svn']
let g:Lf_GtagsAutoGenerate=1

let g:Lf_Gtagsconf = '/usr/local/gtags/share/gtags/gtags.conf'  
let g:Lf_Gtagslabel = 'native-pygments'

let g:Lf_ShortcutF = '<S-M-o>'
let g:Lf_ShortcutB = '<S-M-p>'
let g:Lf_WindowPosition = 'popup'
let g:Lf_ShowRelativePath = 1
let g:Lf_DefaultMode = 'Fuzzy'
let g:Lf_PreviewInPopup = 1

let g:Lf_WildIgnore = {
    \ 'dir': ['.svn','.git','.hg','github.com','golang.org','google.golang.org','pkg','applog'],
    \ 'file': ['*.sw','*.bak','*.exe','*.o','*.so','*.py','*.mod','*.info','*.lock','*.bat','*.md']
    \}

"查找当前文件的函数列表
noremap <M-m> :LeaderfFunction<cr>
