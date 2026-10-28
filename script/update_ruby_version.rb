#!/usr/bin/env ruby

require "json"
require "net/http"
require "uri"

ROOT = File.expand_path("..", __dir__)

def repository_file(path)
  File.join(ROOT, path)
end

def read_file(path)
  File.read(repository_file(path))
end

def replace_one(contents, pattern, replacement, description)
  matches = contents.scan(pattern)
  raise "Expected exactly one #{description}, found #{matches.length}." unless matches.length == 1

  contents.sub(pattern, replacement)
end

def docker_hub_digest(repository, tag)
  uri = URI("https://hub.docker.com/v2/repositories/#{repository}/tags/#{tag}")
  response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 10, read_timeout: 20) do |http|
    http.get(uri.request_uri)
  end

  if response.code == "404"
    raise "Upstream image #{repository}:#{tag} is unavailable. Check that both Ruby images have been published."
  end
  unless response.is_a?(Net::HTTPSuccess)
    raise "Could not verify upstream image #{repository}:#{tag} (HTTP #{response.code})."
  end

  image_metadata = JSON.parse(response.body)
  platforms = image_metadata.fetch("images")
  unless platforms.is_a?(Array) && platforms.any? { |image| image["os"] == "linux" && image["architecture"] == "amd64" }
    raise "Upstream image #{repository}:#{tag} has no linux/amd64 image."
  end

  digest = image_metadata.fetch("digest")
  unless digest.is_a?(String) && digest.match?(/\Asha256:[0-9a-f]{64}\z/)
    raise "Docker Hub returned an invalid digest for #{repository}:#{tag}."
  end

  digest
rescue JSON::ParserError, KeyError
  raise "Docker Hub returned invalid metadata for #{repository}:#{tag}."
end

abort "Usage: ruby script/update_ruby_version.rb <ruby-version>" unless ARGV.length == 1
version = ARGV.fetch(0)
abort "Ruby version must be a complete version such as 4.0.5." unless version.match?(/\A\d+\.\d+\.\d+\z/)
abort "Preparation must run with Ruby #{version}, not #{RUBY_VERSION}." unless version == RUBY_VERSION

ruby_version_file = read_file(".ruby-version")
current_version = ruby_version_file.delete_suffix("\n")
unless ruby_version_file.match?(/\A\d+\.\d+\.\d+\n?\z/) && current_version.match?(/\A\d+\.\d+\.\d+\z/)
  abort "The trusted .ruby-version must contain one complete Ruby version."
end

lockfile = read_file("Gemfile.lock")
lock_versions = lockfile.scan(/^  ruby (\d+\.\d+\.\d+)(?:p\d+)?$/).flatten
unless lock_versions == [current_version]
  abort "Gemfile.lock Ruby metadata must match .ruby-version #{current_version} before updating."
end

app_digest = docker_hub_digest("library/ruby", "#{version}-slim-bookworm")
runner_digest = docker_hub_digest("cimg/ruby", "#{version}-browsers")
app_image = "ruby:#{version}-slim-bookworm@#{app_digest}"
runner_image = "cimg/ruby:#{version}-browsers@#{runner_digest}"

changes = {}
changes[".ruby-version"] = "#{version}\n"
changes["Gemfile"] = replace_one(
  read_file("Gemfile"),
  /^ruby "#{Regexp.escape(current_version)}"$/,
  "ruby \"#{version}\"",
  "Gemfile Ruby requirement",
)

dockerfile = read_file("Dockerfile")
changes["Dockerfile"] = replace_one(
  dockerfile,
  /^FROM ruby:#{Regexp.escape(current_version)}-slim-bookworm@sha256:[0-9a-f]{64} AS base$/,
  "FROM #{app_image} AS base",
  "application Ruby base image",
)

images = read_file("docker-images.json")
image_data = JSON.parse(images)
app_image_pins = image_data.fetch("images").grep(/\Aruby:/)
unless app_image_pins.length == 1 && app_image_pins.first.match?(/\Aruby:#{Regexp.escape(current_version)}-slim-bookworm@sha256:[0-9a-f]{64}\z/)
  abort "docker-images.json must contain exactly one application Ruby image matching #{current_version}."
end
changes["docker-images.json"] = replace_one(
  images,
  Regexp.new(Regexp.escape(app_image_pins.first)),
  app_image,
  "application Ruby image in docker-images.json",
)

runner_dockerfile = read_file("Dockerfile_browser_tools.dockerfile")
changes["Dockerfile_browser_tools.dockerfile"] = replace_one(
  runner_dockerfile,
  /^FROM cimg\/ruby:#{Regexp.escape(current_version)}-browsers@sha256:[0-9a-f]{64}$/,
  "FROM #{runner_image}",
  "runner Ruby base image",
)
changes["Dockerfile_browser_tools.dockerfile"] = replace_one(
  changes["Dockerfile_browser_tools.dockerfile"],
  /^# Use the cimg\/ruby:#{Regexp.escape(current_version)}-browsers image as the base image to extend out$/,
  "# Use the cimg/ruby:#{version}-browsers image as the base image to extend out",
  "runner Ruby base image documentation",
)

circleci = read_file(".circleci/config.yml")
circleci_pins = circleci.scan(/^(\s*-\s*image:\s*cimg\/ruby:)(\d+\.\d+\.\d+)(-browsers\s*)$/)
if circleci_pins.empty? || circleci_pins.any? { |(_, pinned_version, _)| pinned_version != current_version }
  abort "CircleCI Ruby executor pins must all match .ruby-version #{current_version}."
end
changes[".circleci/config.yml"] = circleci.gsub(
  /^(\s*-\s*image:\s*cimg\/ruby:)#{Regexp.escape(current_version)}(-browsers\s*)$/,
  "\\1#{version}\\2",
)

readme = read_file("README.md")
static_runtime = /^- Ruby `#{Regexp.escape(current_version)}` \(see `.ruby-version`\)$/
dynamic_runtime = /^- Ruby version is declared in `.ruby-version`$/
if readme.match?(static_runtime)
  changes["README.md"] = replace_one(readme, static_runtime, "- Ruby version is declared in `.ruby-version`", "README Ruby version")
elsif readme.scan(dynamic_runtime).length == 1
  changes["README.md"] = readme
else
  abort "README.md must identify .ruby-version as the Ruby runtime source."
end

rubocop_workflow = read_file(".github/workflows/rubocop.yml")
current_rubocop_selector = /^(\s*)ruby-version: #{Regexp.escape(current_version)}$/
version_file_selector = /^\s*ruby-version-file: \.ruby-version$/
if rubocop_workflow.match?(current_rubocop_selector)
  changes[".github/workflows/rubocop.yml"] = replace_one(
    rubocop_workflow,
    current_rubocop_selector,
    "\\1ruby-version-file: .ruby-version",
    "RuboCop Ruby selector",
  )
elsif rubocop_workflow.scan(version_file_selector).length == 1
  changes[".github/workflows/rubocop.yml"] = rubocop_workflow
else
  abort "RuboCop must select Ruby using .ruby-version."
end

changes.each do |path, contents|
  File.write(repository_file(path), contents)
end

puts "Updated Ruby pins from #{current_version} to #{version}."
puts "Resolved application image #{app_image}."
puts "Resolved runner image #{runner_image}."
puts "Run `bundle lock` with Ruby #{version} to update Gemfile.lock metadata."
