Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
        origins '*'

        resource '*',
        headers: :any,
        methods: [:get] # The only one in use
    end
end