# Conferences

*Conferences* is a plugin for [Spina](https://www.spinacms.com/) that provides conference management functionality. With the plugin, you'll be able to manage details of conferences, delegates, and presentations.

Spina is a content management system built in [Ruby on Rails](http://rubyonrails.org/). *Conferences* augments Spina by providing an admin interface for managing conferences.

![Rails tests](https://github.com/louis-vs/spina-admin-conferences-fork/workflows/Verify/badge.svg?branch=main&event=push)
[![CodeFactor](https://www.codefactor.io/repository/github/louis-vs/spina-admin-conferences-fork/badge)](https://www.codefactor.io/repository/github/louis-vs/spina-admin-conferences-fork)

## Features

The conferences plugin covers many important aspects of managing a conferences, including:

- Simple interface that builds upon Spina's own.
- Manage details about delegates, including dietary requirements.
- Manage conferences, supporting conferences with multiple host institutions.
- Manage presentations, including presentation types.

Currently, a submissions management system is not included, but this is planned for a future release. This will allow you to manage the submissions process for conferences in a manner integrated with the CMS.

## Usage

The plugin will add a **Conferences** item to Spina's primary navigation menu.
The menu structure will then be as follows:

- *Other menu items*
- Conferences
  - Institutions
  - Conferences
  - Delegates
  - Presentations

After installing the plugin, you just need to start your server in the usual way:
```bash
$ rails s
```

## Installation

### From scratch
Make sure you have a working installation of Ruby on Rails 7. You can find a setup guide [here](https://guides.rubyonrails.org/getting_started.html).

You then need to install Spina, following the guide [on the Spina website](https://spinacms.com/docs).

To install the plugin, add this line to your application's Gemfile:

```ruby
gem 'spina-admin-conferences-fork', '~> 3.0'
```

Then execute:

```bash
$ bundle install
```

You'll then need to install and run the migrations from the plugin:

```bash
$ bin/rails spina_admin_conferences:install:migrations
$ bin/rails db:migrate
```

You can then start a local server to test that everything's working.

```bash
$ bin/rails s
```

You can manually populate the database from within the app, or alternatively you can use seed data for testing. A sample `seeds.rb` file can be found [here](../master/test/dummy/db/seeds.rb).


### Configuring the main Rails app

Conferences requires a job queueing backend for import functionality, and you'll also want to cache pages listing presentations, conferences, and so on. Read about this in the Rails guides covering [Active Job](https://guides.rubyonrails.org/active_job_basics.html) and [caching](https://guides.rubyonrails.org/caching_with_rails.html).

## Contributing

Bug reports and feature requests are welcome in the [Issues](https://github.com/louis-vs/spina-admin-conferences-fork/issues) section. Translations are also very welcome!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
