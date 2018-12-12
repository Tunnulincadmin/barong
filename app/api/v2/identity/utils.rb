# frozen_string_literal: true

module API::V2
  module Identity
    module Utils

      def session
        request.session
      end

      def codec
        @_codec ||= Barong::JWT.new(key: Barong::App.config.keystore.private_key)
      end

      def verify_captcha!(user:, response:, error_statuses: [400, 422])
        captcha_error_message = 'reCAPTCHA verification failed, please try again.'
        error!('recaptcha_response is required', error_statuses.first) if response.blank?
        return if RecaptchaVerifier.new(request: request).verify_recaptcha(model: user,
                                                                          skip_remote_ip: true,
                                                                          response: response)
        error!(captcha_error_message, error_statuses.last)
      rescue StandardError
        error!(captcha_error_message, error_statuses.last)
      end

      def login_error!(options = {})
        options[:data] = { reason: options[:reason] }.to_json
        options[:topic] = 'session'
        activity_record(options.except(:reason, :error_code))
        error!(options[:reason], options[:error_code])
      end

      def activity_record(options = {})
        params = {
          user_id:    options[:user],
          user_ip:    request.ip,
          user_agent: request.env['HTTP_USER_AGENT'],
          topic:      options[:topic],
          action:     options[:action],
          result:     options[:result],
          data:       options[:data]
        }
        Activity.create(params)
      end
    end
  end
end
