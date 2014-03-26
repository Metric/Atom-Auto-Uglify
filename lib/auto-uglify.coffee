UglifyJS = require 'uglify-js'
fs = require 'fs'

compile = () ->
  activeEditor = atom.workspace.getActiveEditor()

  if activeEditor
    filePath = activeEditor.getPath()

    if filePath.indexOf('.js') == filePath.length - 3 and filePath.indexOf('.min.js') == -1
      text = activeEditor.getText()
      result = UglifyJS.minify(text, {fromString: true});


      filenamePath = filePath.replace('.js', '.min.js')
      fs.writeFile(filenamePath, result.code, (err) ->
          if err
            console.log("Failed to save minified javascript file!")
      )

module.exports =
  activate: (state) =>
    atom.workspaceView.command "uglify:compile", => compile()
    atom.workspaceView.command "core:save", => compile()

  deactivate: ->

  serialize: ->
