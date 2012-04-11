# Theses tests should be run against each adapter
{merge} = require '../../lib/util'
racer = require '../../lib/racer'

shouldPassPubSubIntegrationTests = require './integration.pubSub'
shouldPassTransactionIntegrationTests = require './integration.txns'

module.exports = (storeOpts = {}, plugins = []) ->

  describe 'Store integration tests', ->

    racer.Store.MODES.forEach (mode) ->
      describe mode, ->
        beforeEach (done) ->
          for plugin in plugins
            racer.use plugin, plugin.testOpts if plugin.useWith.server
          opts = merge
            mode:
              type: mode
          , storeOpts
          store = @store = racer.createStore opts
          store.flush done

        afterEach (done) ->
          @store.flush done

        shouldPassPubSubIntegrationTests plugins
        shouldPassTransactionIntegrationTests plugins
