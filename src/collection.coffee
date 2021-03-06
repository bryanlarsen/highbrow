
class Collection extends highbrow.Backbone.Collection
  setParent: (@parent) ->

  @init: (context, params...) ->
    coll = new @(params...)
    coll.context = context
    return coll

  initialize: (options={}) ->
    @url = options.url if options.url
    @context = options.context if options.context
    super

  url: ->
    throw new Error("urlRoot not specified for #{@}") unless @urlRoot
    @urlRoot.replace(":parent", @parent?.url())

  sync: (method, model, options) ->
    if highbrow.server
      options ?= {}
      options.context = @context || {}
    highbrow.Backbone.sync.call(this, method, model, options)

  fetchAndContinue: (next) ->
    this.fetch({
      success: -> next()
      error: (model,response) ->
        next(response)
    })
