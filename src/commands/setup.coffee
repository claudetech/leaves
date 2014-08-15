path = require 'path'
npm  = require 'npm'
fs   = require 'fs-extra'

libDir = path.dirname(__dirname)
pathResolver = require path.join(libDir, 'path-resolver')

setupZsh = ->
  home  = process.env.HOME
  return console.error 'Home not set. Aborting zsh setup.' unless home?
  zshrc = path.join home, '.zshrc'
  fs.ensureFileSync zshrc
  fs.ensureDirSync path.join(home, '.leaves', 'zsh')
  zshPath = path.join npm.globalDir, 'leaves', 'tools', 'shells', 'zsh'
  fs.copySync zshPath, path.join(home, '.leaves', 'zsh')

  content = fs.readFileSync zshrc, 'utf8'
  unless content.indexOf('leaves-init.sh') > -1
    fs.appendFileSync zshrc, """
      \n# added by leaves setup.
      [[ -f $HOME/.leaves/zsh/leaves-init.sh ]] && . $HOME/.leaves/zsh/leaves-init.sh\n\n
      """
    console.log "zsh completion added. Your ~/.zshrc file has been appended."
    console.log "run 'exec $SHELL' to activate the completions."

exports.run = (opts) ->
  shell = process.env.SHELL
  if shell? && shell.indexOf('zsh') > -1
    setupZsh()
