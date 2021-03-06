React = require 'react'
Radium = require 'radium'
colors = require './colors/color-definition'

###
@props.table [required] 2 dimension array of ReactElement data
@props.prefix [required] unique text for key's prefix
@props.cellStyles array of styles applied to column
@props.style
###
class DocTableComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <table style={styles.table}>
        <tbody>
          {
            for row, i in @props.table
              odd_even_style = if i % 2 == 1 then {} else {backgroundColor: '#F2F2F2'}
              <tr key={"#{@props.prefix}-#{i}"} style={[styles.tb_row, odd_even_style]}>
                {
                  for cell, j in row
                    dstyle = if j == 0 then styles.tb_key else styles.tb_desc
                    <td key={"#{@props.prefix}-#{i}-#{j}"} style={[styles.tb_item, dstyle, @props.cellStyles?[j]]}>
                      {cell}
                    </td>
                }
              </tr>
          }
        </tbody>
      </table>
    </div>

styles =
  base: {}

  table:
    borderSpacing: 0

  tb_row:
    ':hover':
      backgroundColor: colors.main.n.light

  tb_item:
    paddingTop: 9
    paddingBottom: 7
    paddingLeft: 20
    paddingRight: 20

  tb_key:
    paddingRight: 20
    color: colors.general.r.emphasis

  tb_desc:
    color: colors.general.r.moderate

DocTableComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocTableComponent
