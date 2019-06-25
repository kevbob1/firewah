module Firewah
  class App < Padrino::Application
    set :login_model, :user
    set :credentials_accessor, :visitor

    set :session_secret, 'fcd5c6d03fb88e02f97933961e41d7593072c61c408fd057d1831a1870113f9d'
    set :protection, :except => :path_traversal
    set :protect_from_csrf, true
    pubsub = RedisPubSub.new($REDIS_PUBSUB_READ, $REDIS, "ws")

    set :websockets_pub_sub, pubsub
    
    register ScssInitializer
    register Padrino::Mailer
    register Padrino::Helpers
    register Padrino::Login
    register Padrino::WebSockets

    helpers Sinatra::JSON

    enable :sessions

    #
    # set :raise_errors, true       # Raise exceptions (will stop application) (default for test)
    # set :dump_errors, true        # Exception backtraces are written to STDERR (default for production/development)
    # set :show_exceptions, true    # Shows a stack trace in browser (default for development)
    # set :logging, true            # Logging in STDOUT for development and file for production (default only for development)
    # set :public_folder, 'foo/bar' # Location for static assets (default root/public)
    # set :reload, false            # Reload application files (default in development)
    # set :default_builder, 'foo'   # Set a custom form builder (default 'StandardFormBuilder')
    # set :locale_path, 'bar'       # Set path for I18n translations (default your_apps_root_path/locale)
    # disable :sessions             # Disabled sessions by default (enable if needed)
    # disable :flash                # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
    # layout  :my_layout            # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
    #

    #
    helpers do
      def authorized?
        if visitor
          return true
        else
          return false
        end
      end
    end
  
    websocket :channel do
      on :ping do |message|
     #   send_message(:channel, session['websocket_user'], {pong: true, data: message})
        broadcast(:channel, {"message" => "ping message received", "severity" => "success"})
      end
    end

  end
end
