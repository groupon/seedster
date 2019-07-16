# https://guides.rubyonrails.org/generators.html
module Seedster
  module Generators
    class InitializerGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def copy_initializer_file
        copy_file \
          'initializer.rb',
          'config/initializers/seedster.rb'
      end
    end
  end
end
