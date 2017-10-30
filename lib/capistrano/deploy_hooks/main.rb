require 'json'
require 'net/http'

module Capistrano
  module DeployHooks
    class Main
      extend Forwardable
      def_delegators :@cap, :fetch, :run_locally

      def initialize(cap)
        @env = cap
        opts = fetch(:deploy_hooks, {}).dup

        @messenger = opts.delete(:messenger).new(cap, opts)
      end

      def run(action)
        _self = self
        run_locally{ _self.process(action) }
      end

      def process(action)
        uri = URI(@messenger.webhook_for(action))
        @messenger.payloads_for(action).each do |payload|
          Net::HTTP.post_form(uri, { 'payload' => payload.to_json })
        end
      end
    end
  end
end
