UglifyJS = require 'uglify-js'
fs = require 'fs'

compile = () ->
  activeEditor = atom.workspace.getActiveTextEditor()

  if activeEditor
    filePath = activeEditor.getPath()

    if filePath and filePath.indexOf('.js') == filePath.length - 3 and filePath.indexOf('.min.js') == -1
      text = activeEditor.getText()
      result = UglifyJS.minify(text, {fromString: true});


      filenamePath = filePath.replace('.js', '.min.js')
      fs.writeFile(filenamePath, result.code, (err) ->
          if err
            console.log("Failed to save minified javascript file!")
      )

module.exports =
  activate: (state) =>
    atom.commands.add "atom-workspace",
      "uglify:compile": (event) =>
        compile()

    atom.commands.add "atom-workspace",
      "core:save": (event) =>
        compile()

  deactivate: ->

  serialize: ->
