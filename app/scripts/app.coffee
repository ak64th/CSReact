# React = require('react')
# ReactDOM = require('react-dom')
#
# { div, h1, h2, ul, li, p, a } = React.DOM
#
# contacts = [
#   {key: 1, name: "James Nelson", email: "james@jamesknelson.com"},
#   {key: 2, name: "Bob"}
# ]
#
# contactElement = (contact) ->
#   li
#     key: contact.key
#     h2 {}, contact.name
#     a
#       href: "mailto#{contact.email}"
#       contact.email
#
# listElements = [contactElement(contact) for contact in contacts when contact.email]
#
# ui = div {},
#   h1 {}, 'Contacts'
#   ul {}, listElements
#
# ReactDOM.render ui, document.getElementById 'react-app'

React = require('react')
ReactDOM = require('react-dom')

Component =
  create: (spec) ->
    React.createFactory React.createClass(spec)

{ div, h1, h2, ul, li, p, a } = React.DOM
{ form, input, textarea, button } = React.DOM

ContactItem = React.createClass
  propTypes:
    name: React.PropTypes.string.isRequired
    email: React.PropTypes.string.isRequired
    description: React.PropTypes.string
  render: ->
    li
      className: 'contact-item'
      h2
        className: 'contact-item-name'
        @props.name
      a
        className: 'contact-item-email'
        href: "mailto#{@props.email}"
        @props.email
      div
        className: 'contact-item-description'
        @props.description

ContactForm = React.createClass
  propTypes:
    value: React.PropTypes.object.isRequired
    onChange: React.PropTypes.func.isRequired
    onSubmit: React.PropTypes.func.isRequired
  onNameInput: (ev) ->
    @props.onChange Object.assign {}, @props.value, {name: ev.target.value}
  onEmailInput: (ev) ->
    @props.onChange Object.assign {}, @props.value, {email: ev.target.value}
  onDescriptionInput: (ev) ->
    @props.onChange Object.assign {}, @props.value, {description: ev.target.value}
  onSubmit: (ev) ->
    ev.preventDefault()
    @props.onSubmit()
  render: ->
    form
      className: 'contact-form'
      input
        name: 'name'
        placeholder: 'name (required)'
        value: @props.value.name
        onChange: @onNameInput
      input
        name: 'email'
        placeholder: 'email (required)'
        value: @props.value.email
        onChange: @onEmailInput
      textarea
        name: 'description'
        value: @props.value.description
        onChange: @onDescriptionInput
      button
        type: 'submit'
        onClick: @onSubmit
        'Add Contact'

contactItem = React.createFactory ContactItem
contactForm = React.createFactory ContactForm

ContactView = React.createClass
  propTypes:
    contacts: React.PropTypes.array.isRequired
    newContact: React.PropTypes.object.isRequired
    onNewContactChange: React.PropTypes.func.isRequired
    onNewContactSubmit: React.PropTypes.func.isRequired
  render: ->
    contactItemElements = [contactItem contact for contact in contacts when contact.email]
    div
      className: 'contact-view'
      h1
        className: 'contact-view-title'
        'Contacts'
      ul
        className: 'contact-view-list'
        contactItemElements
      contactForm
        value: @props.newContact
        onChange: @props.onNewContactChange
        onSubmit: @props.onNewContactSubmit

state = {}

setState = (changes) ->
  Object.assign state, changes
  newState = Object.assign state, {
    onNewContactChange: (newContact) -> setState {newContact}
    onNewContactSubmit: -> console.log 'New contact submited'
      # contact = Object.assign {}, state.newContact, {
      #   key: state.contacts.length + 1
      #   errors: {}
      # }
      # if contact.name and contact.email
  }
  rootElement = React.createElement ContactView, newState
  ReactDOM.render rootElement, document.getElementById 'react-app'

contacts = [
  {key: 1, name: "James K Nelson", email: "james@jamesknelson.com", description: "Front-end Unicorn"},
  {key: 2, name: "Jim", email: "jim@example.com"},
  {key: 3, name: "Joe"}
]
newContact =
  name: ''
  email: ''
  description: ''
setState {contacts, newContact}
