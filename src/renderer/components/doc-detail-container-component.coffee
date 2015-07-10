React = require 'react'
Radium = require 'radium'
DocDetailTitleComponent = require './doc-detail-title-component'
DocSlideWrapperComponent = require './doc-slide-wrapper-component'
DocDescriptionComponent = require './doc-description-component'

class DocDetailContainerComponent extends React.Component
  constructor: (props) ->
    super props

  close: ->
    if @props.argu.route_arr[1]?.toString() == 'local'
      @context.ctx.routeAction.navigate(document.location.pathname.match(/^(.+)\/[^\/]+$/)[1])

  render: ->
    file_id = @props.argu.route_arr[2]?.toString()
    factor_id = @props.argu.route_arr[3]?.toString()
    local_factor_id = @props.argu.route_arr[4]?.toString()
    collapsed = false
    if @props.argu.route_arr[1]?.toString() == 'local'
      collapsed = true
    if collapsed
      <DocSlideWrapperComponent style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
        <div style={styles.close} onClick={@close.bind(@)}>
          <span className='icon-close' style={styles.close_icon}></span>
        </div>
        {
          if file_id? && factor_id?
            current = @props.doc_data[file_id]?[factor_id]
            if current?
              current_local = null
              for c in current.children
                if c.id?.toString() == local_factor_id
                  current_local = c
              if current_local?
                <div>
                  <DocDetailTitleComponent current={current_local} from={current} />
                  <DocDescriptionComponent text={current_local.signatures?[0].comment?.shortText} />
                </div>
        }
      </DocSlideWrapperComponent>
    else
      null

styles =
  base:
    boxShadow: '0 0 3px 0 rgba(0, 0, 0, 0.4)'
    backgroundColor: '#fff'

  close:
    position: 'absolute'
    top: 7
    left: 8
    cursor: 'pointer'

  close_icon:
    borderWidth: 0
    fontSize: 20
    color: '#ccc'
    transitionProperty: 'all'
    transitionDuration: '0.1s'
    transitionTimingFunction: 'ease-in-out'

    ':hover':
      color: '#111'

DocDetailContainerComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocDetailContainerComponent