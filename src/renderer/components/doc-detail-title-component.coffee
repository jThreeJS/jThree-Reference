React = require 'react'
Radium = require 'radium'
Link = require './link-component'
DocDetailSignaturesComponent = require './doc-detail-signatures-component'
DocTitleComponent = require './doc-title-component'
DocFlagtagsComponent = require './doc-flagtags-component'
colors = require './colors/color-definition'

###
@props.current [required] local current which is child of current factor
@props.style
###
class DocDetailTitleComponent extends React.Component
  constructor: (props) ->
    super props

  constructLink: (current) ->
    routes = @context.ctx.routeStore.get().routes
    match = current.name.match(/^(.+)\.(.+)$/)
    detail_href = '#'
    factor_href = '#'
    local_match = null
    global_match = null
    for fragment, route of routes
      local_match = route.match new RegExp("^class:local:(.+):(.+):#{current.id}$")
      if local_match
        detail_href = "/#{fragment}"
        break
    for fragment, route of routes
      global_match = route.match new RegExp("^class:global:#{local_match[1]}:#{local_match[2]}$")
      if global_match
        factor_href = "/#{fragment}"
        break
    <span>
      <Link style={styles.link} href={factor_href}>{match[1]}</Link>
      <span>.</span>
      <Link style={styles.link} href={detail_href}>{match[2].replace(/__constructor/, 'constructor')}</Link>
    </span>

  render: ->
    dstyle =
      kind_string:
        borderRadius: 7

    <DocTitleComponent title={".#{@props.current.name}"} kindString={@props.current.kindString} dstyle={dstyle} style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      {
        if @props.current.inheritedFrom?
          <div style={styles.from}>
            <span><span>{"Inherited from "}</span>{@constructLink(@props.current.inheritedFrom)}</span>
          </div>
      }
      {
        if @props.current.overwrites?
          <div style={styles.from}>
            <span><span>{"Overwrites "}</span>{@constructLink(@props.current.overwrites)}</span>
          </div>
      }
      <DocFlagtagsComponent flags={@props.current.flags} style={styles.tags} />
      <DocDetailSignaturesComponent style={styles.signatures} current={@props.current} />
    </DocTitleComponent>

styles =
  base: {}

  from:
    marginBottom: 4

  tags:
    marginTop: 11
    marginBottom: 11

  signatures:
    marginTop: 23

  link:
    color: colors.general.r.light
    textDecoration: 'none'
    cursor: 'pointer'

    ':hover':
      textDecoration: 'underline'

DocDetailTitleComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocDetailTitleComponent
