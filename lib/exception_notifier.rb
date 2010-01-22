require 'action_dispatch'
require 'exception_notifier/notifier'

class ExceptionNotifier
  def initialize(app, options = {})
    @app, @options = app, options
  end

  def call(env)
    @app.call(env)
  rescue Exception => exception
    (env['exception_notifier.options'] ||= {}).reverse_merge!(@options)
    Notifier.deliver_exception_notification(env, exception)
    raise exception
  end
end
