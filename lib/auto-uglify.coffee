UglifyJS = require 'uglify-js'
UglifyES = require 'uglify-es'
fs = require 'fs'

es6Reg = /(let ?)|(const ?)|(=>)|('use strict';?)|("use strict";?)|(import ?)|(export ?)/gi;

compile = () ->
  activeEditor = atom.workspace.getActiveTextEditor()

  if activeEditor
    filePath = activeEditor.getPath()

    if filePath and filePath.indexOf('.js') == filePath.length - 3 and filePath.indexOf('.min.js') == -1
      text = activeEditor.getText()
      result = text
      
      if text.match(es6Reg)
        result = UglifyES.minify(text)
      else
        result = UglifyJS.minify(text, {fromString: true})


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
