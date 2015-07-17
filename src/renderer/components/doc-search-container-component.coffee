React = require 'react'
Radium = require 'radium'
colors = require './colors/color-definition'
DocIncrementalSearchComponent = require './doc-incremental-search-component'
CharIconComponent = require './char-icon-component'

###
@props.style
###
class DocSearchContainerComponent extends React.Component
  constructor: (props) ->
    super props

  componentWillMount: ->
    @setState
      routes: @context.ctx.routeStore.get().routes
      dir_tree: @context.ctx.docStore.get().dir_tree

  genKindStringStyle: (kindString) ->
    color = colors.general.r.default

    switch kindString
      when 'Class'
        color = '#337BFF'
      when 'Constructor'
        color = '#337BFF'
      when 'Interface'
        color = '#598213'
      when 'Property'
        color = '#598213'
      when 'Enumeration'
        color = '#B17509'
      when 'Enumeration member'
        color = '#B17509'
      when 'Module'
        color = '#D04C35'
      when 'Accessor'
        color = '#D04C35'
      when 'Function'
        color = '#6E00FF'
      when 'Method'
        color = '#6E00FF'
      else
        color = colors.general.r.default

    style =
      color: color
      borderColor: color

  callDirTreeByArray: (arr) ->
    dir_tree = @state.dir_tree
    for v, i in arr
      if i != arr.length - 1
        dir_tree = dir_tree.dir?[v]
      else
        file = dir_tree.file?[v]
        if file?
          return file
        else
          return undefined
      if !dir_tree?
        return undefined

  render: ->
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      {
        list = []
        for fragment, route of @state.routes
          if route.split(':')[1] == 'global'
            obj = @callDirTreeByArray(fragment.split('/')[1..])
            char_elm = <CharIconComponent char={obj.kindString[0]} style={@genKindStringStyle(obj.kindString)} />
            list.push
              target: fragment.match(/.+\/(.+?)$/)[1]
              content: [char_elm, 'match']
              href: "/#{fragment}"
          else if route.split(':')[1] == 'local'
            m = fragment.match(/.+\/(.+?)\/(.+?)$/)
            obj = @callDirTreeByArray(fragment.split('/')[1..-2])
            obj_child = obj.children.find((v) -> v.name == fragment.split('/')[-1..][0])
            char_elm = <CharIconComponent char={obj.kindString[0]} style={@genKindStringStyle(obj.kindString)} />
            char_elm_child = <CharIconComponent char={obj_child.kindString[0]} style={@genKindStringStyle(obj_child.kindString)} />
            list.push
              target: "#{m[1]}.#{m[2]}"
              content: [char_elm, char_elm_child, 'match']
              href: "/#{fragment}"
        <DocIncrementalSearchComponent list={list} styles={styles} />
      }
    </div>

styles =
  base: {}

  input:
    paddingTop: 5
    paddingBottom: 5
    paddingRight: 12
    paddingLeft: 12
    fontSize: 16
    fontFamily: '-webkit-body'
    fontWeight: 'normal'
    outline: 'none'
    borderColor: colors.general.r.moderate
    borderWidth: 1
    borderStyle: 'solid'
    width: 300

    ':focus':
      outline: 'none'
      borderColor: colors.general.r.moderate
      boxShadow: "0 0 4px 0 #{colors.general.r.moderate}"

  ul:
    listStyle: 'none'
    paddingLeft: 0

  li:
    fontSize: 14
    marginBottom: 4

DocSearchContainerComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocSearchContainerComponent
