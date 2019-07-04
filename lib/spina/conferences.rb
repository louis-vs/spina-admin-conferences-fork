# frozen_string_literal: true

require 'spina'
require 'spina/conferences/engine'
require 'spina/conferences/theme'
require 'spina/conferences/load_path_extensions'
require 'spina/conferences/association_extensions'
require 'spina/conferences/option_extensions'
require 'spina/conferences/structure_extensions'
require 'js-routes'
require 'icalendar'
require 'octicons_helper'
require 'rails-i18n'

module Spina
  module Conferences #:nodoc:
    THEMES = []
  end
end
