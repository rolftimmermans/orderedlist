# Ordered List

Ordered List is an extension for Active Record that allows you to sort and
reorder records in your database. It is similar to acts_as_list, but uses a
more advanced algorithm based on binary tree paths to achieve greater
flexibility and improve performance.

Ordered List is currently a work in progress and is not suitable for
production use yet.

## Synopsis

In your Gemfile:

  gem "orderedlist"

In your model:

  class Foo < ActiveRecord::Base
    acts_as_ordered_list
  end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Ordered List is copyright (c) 2012 Rolf Timmermans

## License

Ordered List is released under the MIT license.
