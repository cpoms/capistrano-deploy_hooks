module Capistrano
  module DeployHooks
    module Messengers
      class Mattermost
        extend Forwardable
        def_delegators :@cap, :fetch

        attr_reader :opts

        def initialize(cap, opts)
          @cap  = cap
          @opts = opts
        end

        def payloads_for(action)
          method = "payload_for_#{action}"
          return if !respond_to?(method)

          pl = (opts[:payload] || {}).merge(username: "Capistrano").merge(send(method))

          channels = Array(opts[:channels])

          payloads = channels.map{ |c| pl.merge(channel: c) }
          payloads = [pl] if payloads.empty?
          payloads
        end

        def payload_for_updating
          { text: "#{deployer} has started deploying branch #{branch} of #{application} to #{stage}" }
        end

        def payload_for_reverting
          { text: "#{deployer} has started rolling back branch #{branch} of #{application} to #{stage}" }
        end

        def payload_for_updated
          { text: "#{deployer} has finished deploying branch #{branch} of #{application} to #{stage}" }
        end

        def payload_for_reverted
          { text: "#{deployer} has finished rolling back branch of #{application} to #{stage}" }
        end

        def payload_for_failed
          { text: "#{deployer} has failed to #{deploying? ? 'deploy' : 'rollback'} branch #{branch} of #{application} to #{stage}" }
        end

        def webhook_for(_)
          opts[:webhook_uri]
        end

        def deployer
          ENV["USER"] || ENV["USERNAME"]
        end

        def branch
          fetch(:branch)
        end

        def application
          fetch(:application)
        end

        def stage
          fetch(:stage, '')
        end
      end
    end
  end
end
