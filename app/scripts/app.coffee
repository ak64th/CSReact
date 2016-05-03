React = require('react')
ReactDOM = require('react-dom')

CONTACT_TEMPLATE =
  name: ''
  email: ''
  description: ''
  errors: null

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
    @refs.name.focus()
    @props.onSubmit()
  componentDidUpdate: (prevProps) ->
    value = @props.value
    prev = prevProps.value
    hasNewError = value.errors? and value.errors isnt prev.errors
    if @isMounted and hasNewError
      if value.errors.name
        @refs.name.focus()
      else if value.errors.email
        @refs.email.focus()
  render: ->
    errors = @props.value.errors or {}
    form
      className: 'contact-form'
      noValidate: true
      input
        name: 'name'
        className: 'contact-form-error' if errors.name
        placeholder: 'name (required)'
        autoFocus: true
        ref: 'name'
        value: @props.value.name
        onChange: @onNameInput
      input
        name: 'email'
        className: 'contact-form-error' if errors.email
        placeholder: 'email (required)'
        ref: 'email'
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
    div
      className: 'contact-view'
      h1
        className: 'contact-view-title'
        'Contacts'
      ul
        className: 'contact-view-list'
        state.contacts
          .filter((contact) -> contact.email)
          .map(contactItem)
      contactForm
        value: @props.newContact
        onChange: @props.onNewContactChange
        onSubmit: @props.onNewContactSubmit

onNewContactChange = (newContact) -> setState {newContact}

onNewContactSubmit = ->
  contact = Object.assign {}, state.newContact,
    { key: state.contacts.length + 1, errors: {} }
  unless contact.name
    contact.errors.name = ["Please enter your new contact's name"];
  unless /.+@.+\..+/.test contact.email
    contact.errors.email = ["Please enter your new contact's email"]
  setState if Object.keys(contact.errors).length is 0
    newContact: Object.assign {}, CONTACT_TEMPLATE
    contacts: state.contacts[..].concat contact
  else
    newContact: contact

state = {}

setState = (changes) ->
  Object.assign state, changes
  rootElement = React.createElement ContactView,
    Object.assign state, { onNewContactChange, onNewContactSubmit }
  ReactDOM.render rootElement, document.getElementById 'react-app'

setState
  contacts: [
    {key: 1, name: "James K Nelson", email: "james@jamesknelson.com", description: "Front-end Unicorn"}
    {key: 2, name: "Jim", email: "jim@example.com"}
    {key: 3, name: "Joe"}
  ]
  newContact: Object.assign {}, CONTACT_TEMPLATE
