#!/usr/bin/env coffee

fs = require 'fs'
CleanCSS = require 'clean-css'
animationConfig = require './bower_components/animate.css/animate-config.json'

task 'build', 'build demo page css', ->

  animateFile = './bower_components/animate.css/animate.css'

  inRegex = /^.*In.*$/
  outRegex = /^.*Out.*$/

  outputFile = 'animate.css'
  minOutputFile = 'animate.min.css'
  configOutputFile = 'animate.json'

  ret =
    inAnimations: []
    outAnimations: []
    normalAnimations: []

  for key, section of animationConfig
    for animationName of section
      if animationName.match inRegex
        ret.inAnimations.push animationName
      else if animationName.match outRegex
        ret.outAnimations.push animationName
      else
        ret.normalAnimations.push animationName

  content = fs.readFileSync animateFile, {encoding: 'utf8'}

  for type, dict of ret
    if type == 'inAnimations'
      animationTypeName = '.ng-enter-active'
    else if type == 'outAnimations'
      animationTypeName = '.ng-leave-active'
    else
      animationTypeName = ''

    for animationName in dict
      oldClassName = new RegExp("\n\\.#{animationName}\\s*{", 'g')
      newClassName = "\n.#{animationName}#{animationTypeName} {"
      content = content.replace oldClassName, newClassName

  content += '''

  .ui-view-container{
    position:relative;
  }
  .animated.ng-enter,.animated.ng-leave{
    position: absolute;
    top: 0;
    left:15px;
    right:15px;
    z-index:10;
  }
  '''

  minContent = (new CleanCSS).minify(content).styles

  fs.writeFileSync outputFile, content, {encoding: 'utf8'}
  fs.writeFileSync minOutputFile, minContent, {encoding: 'utf8'}
  fs.writeFileSync configOutputFile, JSON.stringify(ret), {encoding: 'utf8'}

  console.log 'build success'
