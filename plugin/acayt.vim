" Very basic support for autocomplete-as-you-type. Assumes that omnifunc
" will be set to something useful.

function CompleteIfNecessary()
  " Only attempt autocomplete if there are some non-whitespace characters
  if !empty(trim(getline('.'))) && &omnifunc != ""
    call feedkeys("\<C-X>\<C-O>")
  endif
endfunction

function CRWithPopup()
  " This attempt to handle autocomplete popups properly; the default support
  " is just awful. Using pumvisible is not sufficient here because we don't
  " want to select a completion if nothing has been selected.
  let state = complete_info()
  if state["selected"] >= 0
    " If we have selected an entry treat <CR> as select
    return "\<C-y>"
  elseif state["pum_visible"]
    " If the popup menu is visible but we've not selected anything, we have to
    " exit the popup menu before sending the <CR>
    return "\<C-y>\<CR>"
  else
    " If no popup menu is displayed, then just treat it as a carriage return.
    return "\<CR>"
  endif
endfunction

function SetupCompletion()
  set completeopt=menuone,noinsert,noselect
  autocmd TextChangedI <buffer> call CompleteIfNecessary()
  inoremap <expr><CR> CRWithPopup()
  inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
endfunction

autocmd BufReadPost,BufNewFile * :call SetupCompletion()
