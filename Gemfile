source "https://rubygems.org"

group :test do
  gem "combustion", "~> 0.3"
  gem "minitest"
  gem "database_cleaner"
  gem "simplecov"
end

group :pg do
  gem "pg"
end

group :mysql do
  gem "mysql2"
end

group :mssql do
  gem "tiny_tds"  # Requires freetds library.
  gem "activerecord-sqlserver-adapter"
end

group :sqlite do
  gem "sqlite3"
end

gemspec
