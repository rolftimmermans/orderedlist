#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rake/testtask"

ADAPTERS = %w[pg mysql mssql sqlite]

namespace :test do
  desc "Run unit tests, and integration test against all databases"
  task :all do
    puts "Unit tests"
    Rake::Task["test:units"].invoke
    ADAPTERS.each do |db|
      ENV["DB"] = db
      puts
      puts "Integration tests for DB=#{db}"
      Rake::Task["test:integration"].execute
    end
  end

  Rake::TestTask.new("units") do |test|
    test.pattern = "test/unit/**/*_test.rb"
  end

  Rake::TestTask.new("integration") do |test|
    test.pattern = "test/integration/**/*_test.rb"
  end
end

desc "Run all tests against default database"
Rake::TestTask.new do |test|
  test.pattern = "test/**/*_test.rb"
end

task default: "test"
