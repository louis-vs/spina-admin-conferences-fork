# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # Presentation records.
      #
      # = Validators
      # Presence:: {#title}, {#date}, {#start_time}, {#start_datetime}, {#abstract}, {#presenters}.
      # Conference date (using {ConferenceDateValidator}):: {#date}.
      # @see ConferenceDateValidator
      #
      # = Translations
      # - {#name}
      # - {#title}
      # - {#abstract}
      class Presentation < ApplicationRecord
        include AttrJson::Record
        include AttrJson::NestedAttributes
        include Spina::Partable
        include Spina::TranslatedContent

        # @!attribute [rw] start_datetime
        #   @return [ActiveSupport::TimeWithZone, nil] the presentation start time

        default_scope { includes(:translations) }

        # @!attribute [rw] title
        #   @return [String, nil] the presentation title
        # @!attribute [rw] abstract
        #   @return [ActionText::RichText, nil] the presentation abstract
        translates :title, fallbacks: true
        translates :abstract, backend: :action_text, fallbacks: true

        # @return [ActiveRecord::Relation] all conferences, ordered by date
        scope :sorted, -> { order start_datetime: :desc }

        # @!attribute [rw] name
        #   @return [String, nil] the presentation title (alias)
        #   @see #title
        alias_attribute :name, :title

        # @!attribute [rw] session
        #   @return [Session, nil] directly associated session
        #   @see Session
        belongs_to :session, -> { includes(:translations) }, inverse_of: :presentations, touch: true
        # @!attribute [rw] presentation_type
        #   @return [PresentationType, nil] Presentation type associated with {#session}
        #   @see PresentationType
        #   @see Session#presentation_type
        has_one :presentation_type, -> { includes(:translations) }, through: :session
        # @!attribute [rw] room
        #   @return [Room, nil] Room associated with {#session}
        #   @see Session
        #   @see Session#room
        has_one :room, -> { includes(:translations) }, through: :session
        # @!attribute [rw] conference
        #   @return [Conference, nil] Conference associated with {#presentation_type}
        #   @see Conference
        #   @see PresentationType#conference
        has_one :conference, -> { includes(:translations) }, through: :presentation_type
        # @!attribute [rw] attachments
        #   @return [ActiveRecord::Relation] directly associated presentation attachments
        #   @note This relation accepts nested attributes.
        #   @note Destroying a presentation destroys associated attachments.
        #   @see Attachment
        has_many :attachments, class_name: 'Spina::Admin::Conferences::PresentationAttachment', dependent: :destroy,
                               inverse_of: :presentation
        # @!attribute [rw] presenters
        #   @return [ActiveRecord::Relation] directly associated delegates
        #   @see Delegate
        has_and_belongs_to_many :presenters, class_name: 'Spina::Admin::Conferences::Delegate', # rubocop:disable Rails/HasAndBelongsToMany
                                             foreign_key: :spina_conferences_presentation_id,
                                             association_foreign_key: :spina_conferences_delegate_id
        accepts_nested_attributes_for :attachments, allow_destroy: true

        validates :title, :start_datetime, :abstract, :presenters, presence: true
        validates :start_datetime, 'spina/admin/conferences/conference_date': true
        validates_associated :presenters
        validates_associated :attachments

        # @!attribute [rw] start_time
        #   @return [ActiveSupport::TimeWithZone, nil] the start time (alias)
        #   @see #start_datetime
        alias_attribute :start_time, :start_datetime

        # Imports a presentation from CSV.
        # @param file [String] the CSV file to be read
        # @return [void]
        # @see PresentationImportJob#perform
        def self.import(file)
          PresentationImportJob.perform_later File.read(file)
        end

        # @return [Date, nil] the start date of the presentation. Nil if the presentation has no start date and time
        def date
          return if start_datetime.blank?

          start_datetime.to_date
        end

        # @return [ActiveSupport::TimeWithZone, nil] the presentation end time. Nil if the presentation has no start date and time
        def finish_datetime
          return if start_datetime.blank?

          start_datetime + presentation_type.duration
        end

        # @return [TZInfo::TimezonePeriod, nil] the time zone period for the presentation
        def time_zone_period
          return if start_datetime.blank?

          start_datetime.period
        end

        # @return [Icalendar::Event] the presentation as an iCal event
        def to_event # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          event = Icalendar::Event.new
          return event if invalid?

          event.dtstart = Icalendar::Values::DateTime.new(start_datetime, tzid: start_datetime.time_zone.tzinfo.name)
          event.dtend = Icalendar::Values::DateTime.new(finish_datetime, tzid: finish_datetime.time_zone.tzinfo.name)
          event.location = session.room_name
          presenters.each { |presenter| event.contact = presenter.full_name_and_institution }
          event.categories = Presentation.model_name.human(count: 0)
          event.summary = title
          event.append_custom_property('alt_description', abstract.to_s)
          event.description = abstract.try(:to_plain_text)
          event
        end
      end
    end
  end
end
