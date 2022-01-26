# frozen_string_literal: true

require 'active_support/concern'

module Spina
  module Admin
    module Conferences
      module Migration
        module Renaming
          extend ActiveSupport::Concern

          included do
            @stale_migrations ||= []
            @migrations_path ||= nil
          end

          class_methods do # rubocop:disable Metrics/BlockLength
            def rename_migration(name, to:)
              config.after_initialize do
                migration = {}
                migration[:old] = migration_hash(name)
                migration[:new] = migration_hash(to)
                @stale_migrations << migration if [migration[:old], migration[:new]].pluck(:file).all?(&:present?)
              end
            end

            def raise_on_duplicate_migrations!
              raise DuplicateMigrationsError, @stale_migrations if @stale_migrations.any?
            end

            private

            attr_reader :duplicate_migrations

            class DuplicateMigrationsError < ::StandardError # rubocop:disable Lint/ConstantDefinitionInBlock
              def initialize(migrations)
                messages = migrations.collect { |migration| generate_message(migration) }
                super(messages.join("\n"))
              end

              private

              MIGRATION_REGEXP = /([0-9]+)_.+\.(spina(_admin)?_conferences).rb$/.freeze

              def generate_message(migration) # rubocop:disable Metrics/AbcSize
                old_version, old_scope = parse_filename(migration[:old][:file])
                messages = []
                messages << "#{File.basename(migration[:new][:file])} is a renamed version of #{File.basename(migration[:old][:file])}."
                messages << "Rename #{File.basename(migration[:old][:file])} to #{old_version}_#{migration[:new][:name]}.#{old_scope}.rb " \
                            "and delete #{File.basename(migration[:new][:file])}."
                messages.join("\n")
              end

              def parse_filename(filename)
                filename.scan(MIGRATION_REGEXP).first
              end
            end

            def migration_hash(name)
              { name: name, file: detect_migration(name) }
            end

            def migrations_path
              @migrations_path || ActiveRecord::Tasks::DatabaseTasks.migrations_paths.first
            end

            def engine_migration_glob(name)
              "#{migrations_path}/**/*_#{name}.spina{_admin,}_conferences_engine.rb"
            end

            def detect_migration(name)
              Dir[engine_migration_glob(name)].first
            end
          end
        end
      end
    end
  end
end
