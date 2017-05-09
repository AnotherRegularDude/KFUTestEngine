namespace :pronto do
  desc "Run pronto to analys project's code"
  task :analyze do
    Pronto::GemNames.new.to_a.each { |gem_name| require "pronto/#{gem_name}" }

    formatter = Pronto::Formatter::GithubFormatter.new
    status_formatter = Pronto::Formatter::GithubStatusFormatter.new
    formatters = [formatter, status_formatter]
    Pronto.run('origin/master', '.', formatters)
  end
end
