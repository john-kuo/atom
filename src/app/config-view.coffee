{View, $$} = require 'space-pen'
$ = require 'jquery'
_ = require 'underscore'
EditorConfigPanel = require 'editor-config-panel'

module.exports =
class ConfigView extends View
  registerDeserializer(this)

  @deserialize: ({activePanelName}) ->
    view = new ConfigView()
    view.showPanel(activePanelName)
    view

  @content: ->
    @div id: 'config-view', =>
      @ol id: 'panel-menu', outlet: 'panelMenu'
      @div id: 'panels', outlet: 'panels'

  initialize: ->
    @panelsByName = {}
    document.title = "Atom Configuration"
    @on 'click', '#panel-menu li', (e) =>
      @showPanel($(e.target).attr('name'))

    @addPanel('General', $$ -> @div "General")
    @addPanel('Editor', new EditorConfigPanel)

  addPanel: (name, panel) ->
    panelItem = $$ -> @li name: name, name
    @panelMenu.append(panelItem)
    panel.hide()
    @panelsByName[name] = panel
    @panels.append(panel)
    @showPanel(name) if @getPanelCount() is 1 or @panelToShow is name

  getPanelCount: ->
    _.values(@panelsByName).length

  showPanel: (name) ->
    if @panelsByName[name]
      @panels.children().hide()
      @panelMenu.children('.active').removeClass('active')
      @panelsByName[name].show()
      @panelMenu.children("[name='#{name}']").addClass('active')
      @activePanelName = name
      @panelToShow = null
    else
      @panelToShow = name

  serialize: ->
    deserializer: @constructor.name
    activePanelName: @activePanelName
