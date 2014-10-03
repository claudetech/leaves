npm  = require 'npm'
path = require 'path'
fs   = require 'fs-extra'
_    = require 'lodash'

exports.copyZshSetup = ->
  return if _.isEmpty(process.env.HOME)
  fs.ensureDirSync path.join(process.env.HOME, '.leaves', 'zsh')
  zshPath = path.join npm.globalDir, 'leaves', 'tools', 'shells', 'zsh'
  fs.copySync zshPath, path.join(process.env.HOME, '.leaves', 'zsh')

exports.setupZsh = ->
  home  = process.env.HOME
  return console.error 'Home not set. Aborting zsh setup.' unless home?
  zshrc = path.join home, '.zshrc'
  fs.ensureFileSync zshrc
  exports.copyZshSetup()

  content = fs.readFileSync zshrc, 'utf8'
  unless content.indexOf('leaves-init.sh') > -1
    fs.appendFileSync zshrc, """
      \n# added by leaves setup.
      [[ -f $HOME/.leaves/zsh/leaves-init.sh ]] && . $HOME/.leaves/zsh/leaves-init.sh\n\n
      """
    console.log "zsh completion added. Your ~/.zshrc file has been appended."
    console.log "run 'exec $SHELL' to activate the completions."
