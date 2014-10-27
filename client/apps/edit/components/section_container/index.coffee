#
# Generic section container component that handles things like hover controls
# and editing states. Also decides which section to render based on the
# section type.
#

SectionText = require '../section_text/index.coffee'
SectionArtworks = require '../section_artworks/index.coffee'
SectionImage = require '../section_image/index.coffee'
React = require 'react'
{ div, nav, button } = React.DOM
icons = -> require('./icons.jade') arguments...

module.exports = React.createClass

  onClickOff: ->
    @setEditing(false)()
    @refs.section?.onClickOff?()

  setEditing: (editing) -> =>
    return if editing is @props.editing
    @props.onSetEditing if editing then @props.key else null

  deleteSection: ->
    @props.section.destroy()

  render: ->
    div {
      className: 'edit-section-container'
      'data-state-editing': @props.editing
      'data-type': @props.section.get('type')
    },
      div {
        className: 'edit-section-hover-controls'
        onClick: @setEditing(on)
      },
        button {
          className: 'edit-section-remove button-reset'
          onClick: @deleteSection
          dangerouslySetInnerHTML: __html: $(icons()).filter('.remove').html()
        }
      (switch @props.section.get('type')
        when 'text' then SectionText
        when 'artworks' then SectionArtworks
        when 'image' then SectionImage
      )(
        section: @props.section
        editing: @props.editing
        ref: 'section'
        onClick: @setEditing(on)
        setEditing: @setEditing
      )
      div {
        className: 'edit-section-container-bg'
        onClick: @onClickOff
      }