#!/usr/bin/env coffee

fs = require 'fs'
CleanCSS = require 'clean-css'
animateConfig = require './node_modules/animate.css/animate-config.json'

animateFile = './node_modules/animate.css/animate.css'

inRegex = /^.*In.*$/
outRegex = /^.*Out.*$/

outputFile = 'animate.css'
minOutputFile = 'animate.min.css'
configOutputFile = 'animate.json'

ret =
    inAnimations: []
    outAnimations: []
    normalAnimations: []

for key, section of animateConfig
    for name, value of section
        if name.match inRegex
            ret.inAnimations.push name
        else if name.match outRegex
            ret.outAnimations.push name
        else
            ret.normalAnimations.push name

content = fs.readFileSync animateFile, {encoding: 'utf8'}

for type, dict of ret
    if type == 'inAnimations'
        typeClassName = '.ng-enter'
    else if type == 'outAnimations'
        typeClassName = '.ng-leave'
    else typeClassName = ''

    for name in dict
        className = ".#{name}"
        newClassName = ".#{name}#{typeClassName}"
        content = content.replace className, newClassName

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

minContent = (new CleanCSS).minify content

fs.writeFileSync outputFile, content, {encoding: 'utf8'}
fs.writeFileSync minOutputFile, minContent, {encoding: 'utf8'}
fs.writeFileSync configOutputFile, JSON.stringify(ret), {encoding: 'utf8'}
