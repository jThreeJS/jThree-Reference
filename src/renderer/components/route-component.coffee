React = require 'react'
Radium = require 'radium'
Router = require '../lib/router'

###
Routing support component

*** Props ***
@props.addStyle {obj|array} active children's style object or array of it
@props.style {obj|array} this style object or array of it

*** Usage ***

-- General routing
Only rendered child component which has @props.route equal to current routing.

Example:
<Route>
  <Index route='index' />
  <About route='about' />
</Route>


-- Inverse routing
Only rendered child component which has @props.route not equal to current routing.

Example:
<Route>
  <Header notroute='index' />
</Route>


-- Only add styles
If @props.addStyle is provided, all children components are visibled, but child
component which has @props.route equals to current routing is given @props.style
specified by @props.addStyle.

Example:
<Route addStyle={styles.active}>
  <li route='index'>Index</li>
  <li route='about'>About</li>
</Route>
styles =
  active:
    backgroundColor: '#f00'


-- Special routing
If children components has no @props.route, always all components are visible.
Children components can get routing by @props.argu and construct individual
routing inside its component. @props.argu is always given in other style of usage.

Summary of @props.argu object:
@props.argu.match {array} match data from fragment
@props.argu.route {string} current route
@props.argu.route_arr {array} current route string splited by ":"
@props.argu.fragment {string} current url fragment
@props.argu.fragment_arr {array} current url fragment splited by "/"

Example:
<Route>
  <List />
</Route>

###
class RouteComponent extends React.Component
  constructor: (props) ->
    super props

  _onChange: ->
    @setState @store.get()

  componentWillMount: ->
    @store = @context.ctx.routeStore
    state = @store.get()
    @setState state

    @router = new Router state.root, state.routes
    @router.setAuth state.auth

  componentDidMount: ->
    @store.onChange @_onChange.bind(@)

  componentWillUnmount: ->
    @store.removeChangeListener(@_onChange.bind(@))

  # shouldComponentUpdate: (nextProps, nextState) ->

  render: ->
    <div style={@props.style}>
      {
        # _children_arr = []
        # React.Children.forEach @props.children, (c) -> _children_arr.push c
        # console.log 'route', (+new Date()).toString()[-4..-1], _children_arr.map (c) -> c.type?.displayName || c.type?.name || c.type
        @router.route @state.fragment, @props.logined, (route, argu, default_route, fragment, default_fragment) =>
          if default_route? && default_fragment?
            @context.ctx.routeAction.navigate(fragment, {replace: true, silent: true})
          React.Children.map @props.children, (child) =>
            if child.props.route? || child.props.notroute?
              match = false
              route_arr = route.split(':')
              (child.props.route || child.props.notroute).split(':').forEach (r, i) ->
                if r == route_arr[i]
                  match = true
                else
                  match = false
              match = !match if child.props.notroute?
              if match
                if @props.addStyle?
                  React.cloneElement child,
                    argu: argu
                    style: Array.prototype.concat.apply([], [child.props.style, @props.addStyle])
                else
                  React.cloneElement child,
                    argu: argu
              else
                if @props.addStyle?
                  React.cloneElement child,
                    argu: argu
                else
                  null
            else
              React.cloneElement child,
                argu: argu
        , (route, argu, default_route) =>
          <h1>404 NotFound</h1>
      }
    </div>

RouteComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium RouteComponent
