# Helper methods defined here can be accessed in any controller or view in the application

module Firewah
  class App
    module HomeHelper
      # def simple_helper_method
      # ...
      # end
      def foo
        return nil
      end
    end

    helpers HomeHelper
  end
end
