# frozen_string_literal: true

require_dependency 'v2/validations'

module API::V2
  # Base api configuration for V2 module
  class Base < Grape::API
    mount Admin::Base      => '/admin'
    mount Identity::Base   => '/identity'
    mount Resource::Base   => '/resource'
    mount Management::Base => '/management'

    route :any, '*path' do
      error! 'Route is not found', 404
    end
  end
end
