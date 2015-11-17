React = require 'react'
Radium = require 'radium'
OverviewMarkupComponent = require './overview-markup-component'
OverviewSidebarComponent = require './overview-sidebar-component'
Route = require './route-component'
Promise = require 'superagent'

$ = React.createElement

class OverviewComponent extends React.Component

  constructor: (props) ->
    super props

  _onChange: ->
    @setState @store.get()
    titleId = Number(@props.argu.route_arr[1]) || 0
    @context.ctx.overviewAction.updateOverview(titleId)

  componentWillMount: ->
    titleId = Number(@props.argu.route_arr[1]) || 0
    # @context.ctx.overviewAction.updateOverview(titleId)
    @store = @context.ctx.overviewStore
    @setState @store.get()
    @context.ctx.overviewAction.updateOverview(titleId)

  componentDidMount: ->
    @store.onChange @_onChange.bind(@)

  shouldComponentUpdate: (nextProps, nextState) ->
    @props.argu.route == nextProps.argu.route
    # @state.markup != nextState.markup

  componentWillUnmount: ->
    @store.removeChangeListener(@_onChange.bind(@))

  render: ->
    console.log @state.structure, @state.markup
    $ 'div', style: Array.prototype.concat.apply([], [styles.base, @props.style]),
      $ 'div', style: styles.sidebar,
        $ Route, {},
          $ OverviewSidebarComponent, structure: @state.structure
      $ 'div', style: styles.contents,
        $ Route, {},
          $ OverviewMarkupComponent, markup: @state.markup

styles =

  base:
    display: '-webkit-flex'
    display: 'flex'
    WebkitFlexDirection: 'row'
    flexDirection: 'row'
    width: '100%'

  sidebar:
    boxSizing: 'border-box'
    paddingLeft: 10
    paddingTop: 10
    width: 360
    borderRight: '1px solid #ccc'
    position: 'fixed'
    top: 80
    height: 'calc(100% - 80px)'
    overflowY: 'scroll'
    overflowX: 'hidden'
    zIndex: 10
    backgroundColor: '#fff'

  contents:
    boxSizing: 'border-box'
    width: 800
    padding: '0 80px 0 40px'
    flexGrow: '1'
    WebkitFlexGrow: '1'
    display: 'flex'
    display: '-webkit-flex'
    flexDirection: 'column'
    WebkitFlexDirection: 'column'
    flexWrap: 'nowrap'
    WebkitFlexWrap: 'nowrap'
    marginLeft: 360


OverviewComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium OverviewComponent
