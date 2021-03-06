proc { |p| $:.unshift(p) unless $:.any? { |lp| File.expand_path(lp) == p } }.call(File.expand_path(File.dirname(__FILE__)))

require 'api_hammer/version'

require 'i18n'
# this weirdness is because enforce_available_locales complains when you try to use the default locale 
# with no translations stored. usually the application will have stored translations in the locale, but, 
# not always, so we put a dummy key in.
I18n.backend.store_translations(I18n.locale, {__api_hammer__: ''})

module ApiHammer
  autoload :Rails, 'api_hammer/rails'
  autoload :Sinatra, 'api_hammer/sinatra'
  autoload :RequestLogger, 'api_hammer/request_logger'
  autoload :ShowTextExceptions, 'api_hammer/show_text_exceptions'
  autoload :TrailingNewline, 'api_hammer/trailing_newline'
  autoload :Weblink, 'api_hammer/weblink'
  autoload :RailsOrSidekiqLoggerMiddleware, 'api_hammer/rails_or_sidekiq_logger'
  autoload :RailsOrSidekiqLogger, 'api_hammer/rails_or_sidekiq_logger'
  autoload :FaradayOutputter, 'api_hammer/faraday/outputter'
  autoload :FaradayCurlVOutputter, 'api_hammer/faraday/outputter'
  autoload :Body, 'api_hammer/body'
  autoload :ContentTypeAttrs, 'api_hammer/content_type_attrs'
  autoload :JsonScriptEscapeHelper, 'api_hammer/json_script_escape_helper'
  module Faraday
    autoload :RequestLogger, 'api_hammer/faraday/request_logger'
  end
  module Filtration
    autoload :Json, 'api_hammer/filtration/json'
    autoload :FormEncoded, 'api_hammer/filtration/form_encoded'
  end
end

require 'faraday'
if Faraday.respond_to?(:register_middleware)
  Faraday.register_middleware(:request, :api_hammer_request_logger => proc { ApiHammer::Faraday::RequestLogger })
end
if Faraday::Request.respond_to?(:register_middleware)
  Faraday::Request.register_middleware(:api_hammer_request_logger => proc { ApiHammer::Faraday::RequestLogger })
end
