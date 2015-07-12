React = require 'react'
Radium = require 'radium'
DocSignaturesTypeargumentsComponent = require './doc-signatures-typearguments-component'

###
type.name<typeArgument, ...>[]

@props.type [required]
@props.emphasisStyle
@props.style
###
class DocSignaturesTypeComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <span style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      {
        elm = []
        if !@props.type.name? && @props.type.type == 'reflection'
          # type.name
          #
          # TODO
          #
          name = ''
          if @props.type.declaration?.signatures?
            name = 'function'
          else if @props.type.declaration?.children?
            name = 'object'
          elm.push <span style={[@props.emphasisStyle, styles.oblique]}>{name}</span>
        else
          # type.name
          elm.push <span style={[@props.emphasisStyle, styles.oblique]}>{@props.type.name}</span>
          # <typeArguments, ...>
          if @props.type.typeArguments
            elm.push <DocSignaturesTypeargumentsComponent typeArguments={@props.type.typeArguments} emphasisStyle={@props.emphasisStyle} />
          # []
          if @props.type.isArray
            elm.push <span>[]</span>
        elm
      }
    </span>

styles =
  base: {}

  oblique:
    fontStyle: 'italic'

DocSignaturesTypeComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocSignaturesTypeComponent
