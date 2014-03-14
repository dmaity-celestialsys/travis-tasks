module Travis
  module Tasks
    class ErrorHandler
      def call(worker, job, queue)
        yield
      rescue => ex
        Sidekiq.logger.warn(ex)

        if Travis.config.sentry.any?
          Raven.capture_exception(ex, context)
        end

        raise
      end
    end
  end
end