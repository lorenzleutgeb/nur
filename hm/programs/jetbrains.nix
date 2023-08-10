{pkgs, ...}: {
  home.packages = with pkgs.jetbrains; [idea-ultimate clion];

  xdg.configFile."ideavim/ideavimrc".text = ''
    source ~/.config/nvim/simple.vim
    " https://github.com/JetBrains/ideavim/tree/e8ba919661242c94e155f6e047330aa86745f3cd/doc
    imap jj <Esc>

    " Refactoring and Generation
    map <leader>c :action RenameElement<cr>
    map <leader>n :action Generate<cr>
    map <leader>r :action RefactoringMenu<cr>

    " Actions
    :command runmenu :action RunMenu
    :command run :action Run

    map <leader><space> :action Run<cr>
    map <leader>y :action CopySpecial<cr>

    " map <leader>c :action EditorCompleteStatement<cr>
    map <leader>p :action ParameterInfo<cr>

    " Navigation

    " Go to next/prev error.
    map <leader>ge :action GotoNextError<CR>
    map <leader>gE :action GotoPreviousError<CR>
    map <leader>gd :action GotoDefinition<cr>
    map <leader>gi :action GotoImplementation<cr>
    map <leader>gr :action GotoRelated<cr>
    map <leader>gs :action GotoSymbol<cr>
    map <leader>gt :action GotoTest<cr>
  '';
}
