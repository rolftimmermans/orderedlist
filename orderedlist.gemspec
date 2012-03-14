# -*- encoding: utf-8 -*-
require File.expand_path("../lib/ordered_list/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Rolf Timmermans"]
  gem.email         = ["rolftimmermans@voormedia.com"]
  gem.description   = %q{Extension for ActiveRecord that provides support for sorting and reordering rows in a database.}
  gem.summary       = %q{Sorting and reordering for ActiveRecord.}
  gem.homepage      = "https://github.com/rolftimmermans/orderedlist"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "orderedlist"
  gem.require_paths = ["lib"]
  gem.version       = OrderedList::VERSION

  gem.add_dependency("activerecord", "~> 3.0")
end
