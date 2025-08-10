# lib/tasks/docs.rake
namespace :docs do
  desc "Runs RSpec tests and generates Swagger documentation"
  task swaggerize: :environment do
    puts "Running RSpec tests..."
    # The `sh` command executes a shell command.
    # The `true` at the end prevents the script from stopping if rspec returns a non-zero exit code.
    # You might remove `|| true` if you want the rake task to fail immediately on a test failure.
    sh "bundle exec rspec"

    puts "Generating Swagger documentation..."
    Rake::Task["rswag:specs:swaggerize"].invoke
    puts "Documentation generated."
  end
end
