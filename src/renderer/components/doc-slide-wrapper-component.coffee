React = require 'react'
Radium = require 'radium'
objectAssign = require 'object-assign'
clone = require 'lodash.clone'
colors = require './colors/color-definition'

###
@props.children[0] [require] to be left
@props.children[1] [require] to be right
@props.style
###
class DocSlideWrapperComponent extends React.Component
  constructor: (props) ->
    super props

  handleEvent: (e) ->
    if e.type == 'resize'
      @updateWrapperWidth()

  updateWrapperWidth: ->
    wrapperWidth = React.findDOMNode(@refs.docWrapper).clientWidth - slide.from
    if @state.wrapperWidth != wrapperWidth
      @setState
        wrapperWidth: wrapperWidth

  # componentDidUpdate: ->
  #   @updateWrapperWidth()

  componentDidMount: ->
    @updateWrapperWidth()
    window.addEventListener 'resize', @

  componentWillUnmount: ->
    window.removeEventListener 'resize', @

  close: ->
    if @props.argu.route_arr[1]?.toString() == 'local'
      @context.ctx.routeAction.navigate(document.location.pathname.match(/^(.+)\/[^\/]+$/)[1])

  search: ->
    @context.ctx.routeAction.navigate '/class'

  render: ->
    # console.log "render DocSlideWrapper", (+new Date()).toString()[-4..-1]
    dstyle = {}
    collapsed = false
    if @props.argu.route_arr[1]?.toString() == 'local'
      collapsed = true
    if collapsed
      dstyle.left =
        boxSizing: 'border-box'
        flexGrow: '0'
        WebkitFlexGrow: '0'
        width: slide.from
        paddingLeft: 18
        paddingRight: 0
        overflow: 'hidden'
        whiteSpace: 'nowrap'
        transitionProperty: 'all'
        transitionDuration: '0.1s'
        # transitionDelay: '0.5s'
        transitionTimingFunction: 'ease-in-out'

        ':hover':
          width: slide.to
    if @state.wrapperWidth
      dstyle.wrapper =
          width: @state.wrapperWidth
    props = {}
    for k, v of @props
      if k != 'children' && k != 'style'
        props[k] = clone v, true
    objectAssign props,
      collapsed: collapsed
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])} ref='docWrapper'>
      <div style={[styles.left, dstyle.left]} ref='docLeft' onClick={@close.bind(@)}>
        {
          React.Children.map @props.children, (c, i) ->
            React.cloneElement c, props if i == 0
        }
      </div>
      {
        if collapsed
          <div style={styles.right} ref='docRight'>
            <div style={styles.close} onClick={@close.bind(@)}>
              <span className='icon-close' style={styles.close_icon} key='icon-close'></span>
            </div>
            <div style={[styles.wrapper, dstyle.wrapper]}>
              {
                React.Children.map @props.children, (c, i) ->
                  React.cloneElement c, props if i == 1
              }
            </div>
          </div>
      }
      {
        if @props.argu.route_arr[0] == 'class' && @props.argu.route_arr.length != 1
          <div style={styles.search} onClick={@search.bind(@)}>
            <span className='icon-search' style={styles.search_icon} key='icon-search'></span>
          </div>
      }
    </div>

slide =
  from:
    120
  to:
    210

styles =
  base:
    display: 'flex'
    flexDirection: 'row'
    WebkitFlexDirection: 'row'
    flexWrap: 'nowrap'
    WebkitFlexWrap: 'nowrap'
    flexGrow: '1'
    WebkitFlexGrow: '1'
    position: 'relative'

  left:
    paddingLeft: 50
    paddingRight: 50
    paddingTop: 30
    paddingBottom: 30
    boxSizing: 'border-box'
    flexGrow: '1'
    WebkitFlexGrow: '1'

  right:
    flexGrow: '1'
    WebkitFlexGrow: '1'
    position: 'relative'
    overflow: 'hidden'
    boxShadow: '0 0 3px 0 rgba(0, 0, 0, 0.4)'
    backgroundColor: '#fff'

  close:
    position: 'absolute'
    top: 7
    left: 8
    cursor: 'pointer'
    zIndex: '1'

  close_icon:
    fontSize: 20
    color: colors.general.r.light
    transitionProperty: 'all'
    transitionDuration: '0.1s'
    transitionTimingFunction: 'ease-in-out'

    ':hover':
      color: colors.general.r.default

  search:
    position: 'absolute'
    top: 7
    right: 8
    cursor: 'pointer'
    zIndex: '1'

  search_icon:
    fontSize: 23
    color: colors.general.r.light
    transitionProperty: 'all'
    transitionDuration: '0.1s'
    transitionTimingFunction: 'ease-in-out'

    ':hover':
      color: colors.general.r.default

  wrapper:
    position: 'absolute'
    top: 0
    left: 0
    bottom: 0
    paddingLeft: 50
    paddingRight: 50
    paddingTop: 30
    paddingBottom: 30
    boxSizing: 'border-box'
    zIndex: '0'

DocSlideWrapperComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocSlideWrapperComponent
