require 'action_mailer'
require 'pp'

class ExceptionNotifier
  class Notifier < ActionMailer::Base
    self.mailer_name = 'exception_notifier'
    self.view_paths << "#{File.dirname(__FILE__)}/views"

    class << self
      def default_sender_address
        %("Exception Notifier" <exception.notifier@default.com>)
      end

      def default_exception_recipients
        []
      end

      def default_email_prefix
        "[ERROR] "
      end

      def default_sections
        %w(request session environment backtrace)
      end

      def default_options
        { :sender_address => default_sender_address,
          :exception_recipients => default_exception_recipients,
          :email_prefix => default_email_prefix,
          :sections => default_sections }
      end
    end

    def exception_notification(env, exception)
      @env        = env
      @exception  = exception
      @options    = (env['exception_notifier.options'] || {}).reverse_merge(self.class.default_options)
      @controller = env['action_controller.instance']
      @request    = ActionDispatch::Request.new(env)
      @backtrace  = clean_backtrace(exception)
      @sections   = @options[:sections]
      data        = env['exception_notifier.exception_data'] || {}

      data.each do |name, value|
        instance_variable_set("@#{name}", value)
      end

      content_type "text/plain"

      prefix   = "#{@options[:email_prefix]}#{@controller.controller_name}##{@controller.action_name}"
      subject    "#{prefix} (#{@exception.class}) #{@exception.message.inspect}"

      recipients @options[:exception_recipients]
      from       @options[:sender_address]

      render "#{mailer_name}/exception_notification"
    end

    private
      def clean_backtrace(exception)
        Rails.respond_to?(:backtrace_cleaner) ?
          Rails.backtrace_cleaner.send(:filter, exception.backtrace) :
          exception.backtrace
      end
  end
end
