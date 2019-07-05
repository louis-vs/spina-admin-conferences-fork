# frozen_string_literal: true

module Spina
  Account.first_or_create name: 'Conferences', theme: 'conference'
  User.first_or_create name: 'Joe', email: 'someone@someaddress.com', password: 'password', admin: true
  module Conferences
    def self.conference_parts
      current_theme = ::Spina::Theme.find_by_name(::Spina::Account.first.theme)
      conference = Conference.new
      conference.model_parts(current_theme).collect { |part| conference.part(part) }
    end
    def self.presentation_parts
      current_theme = ::Spina::Theme.find_by_name(::Spina::Account.first.theme)
      presentation = Presentation.new
      presentation.model_parts(current_theme).collect { |part| presentation.part(part) }
    end
    Institution.create!(
      name: 'University of Atlantis',
      city: 'Atlantis',
      rooms: [
        Room.new(building: 'Lecture block', number: '2'),
        Room.new(building: 'Lecture block', number: '3'),
        Room.new(building: 'Lecture block', number: 'entrance')
      ]
    )
    Institution.create!(
      name: 'University of Shangri-La',
      city: 'Shangri-La',
      rooms: [
        Room.new(building: 'Medical school', number: 'G.14'),
        Room.new(building: 'Medical school', number: 'G.152'),
        Room.new(building: 'Medical school', number: 'G.16')
      ]
    )
    Conference.create!(
      institution: Institution.find_by(name: 'University of Atlantis'),
      start_date: '2017-04-07',
      finish_date: '2017-04-09',
      rooms: Room.includes(:institution).where(spina_conferences_institutions: { name: 'University of Atlantis' }),
      parts: conference_parts
    )
    Conference.create!(
      institution: Institution.find_by(name: 'University of Shangri-La'),
      start_date: '2018-04-09',
      finish_date: '2018-04-11',
      rooms: Room.includes(:institution).where(spina_conferences_institutions: { name: 'University of Shangri-La' }),
      parts: conference_parts
    )
    PresentationType.create! [{
      conference: Conference.includes(:institution).find_by(spina_conferences_institutions: { name: 'University of Atlantis' }),
      name: 'Plenary',
      minutes: 80,
      room_possessions: RoomPossession.includes(:room, :institution).where(
        spina_conferences_institutions: { name: 'University of Atlantis' },
        spina_conferences_rooms: { building: 'Lecture block', number: '3' }
      )
    }, {
      conference: Conference.includes(:institution).find_by(spina_conferences_institutions: { name: 'University of Atlantis' }),
      name: 'Poster',
      minutes: 30,
      room_possessions: RoomPossession.includes(:room, :institution).where(
        spina_conferences_institutions: { name: 'University of Atlantis' },
        spina_conferences_rooms: { building: 'Lecture block', number: 'entrance' }
      )
    }, {
      conference: Conference.includes(:institution).find_by(spina_conferences_institutions: { name: 'University of Atlantis' }),
      name: 'Talk',
      minutes: 20,
      room_possessions: RoomPossession.includes(:room, :institution).where(
        spina_conferences_institutions: { name: 'University of Atlantis' },
        spina_conferences_rooms: { building: 'Lecture block', number: ['2', '3'] }
      )
    }, {
      conference: Conference.includes(:institution).find_by(spina_conferences_institutions: { name: 'University of Shangri-La' }),
      name: 'Plenary',
      minutes: 80,
      room_possessions: RoomPossession.includes(:room, :institution).where(
        spina_conferences_institutions: { name: 'University of Shangri-La' },
        spina_conferences_rooms: { building: 'Medical school', number: 'G.152' }
      )
    }, {
      conference: Conference.includes(:institution).find_by(spina_conferences_institutions: { name: 'University of Shangri-La' }),
      name: 'Poster',
      minutes: 30,
      room_possessions: RoomPossession.includes(:room, :institution).where(
        spina_conferences_institutions: { name: 'University of Shangri-La' },
        spina_conferences_rooms: { building: 'Medical school', number: 'G.14' }
      )
    }, {
      conference: Conference.includes(:institution).find_by(spina_conferences_institutions: { name: 'University of Shangri-La' }),
      name: 'Talk',
      minutes: 20,
      room_possessions: RoomPossession.includes(:room, :institution).where(
        spina_conferences_institutions: { name: 'University of Shangri-La' },
        spina_conferences_rooms: { building: 'Medical school', number: ['G.152', 'G.16'] }
      )
    }]
    Delegate.create!(
      first_name: 'Joe',
      last_name: 'Bloggs',
      institution: Institution.find_by(name: 'University of Atlantis'),
      email_address: 'someone@someaddress.com',
      conferences: Conference.includes(:institution).where(spina_conferences_institutions: {
        name: ['University of Atlantis', 'University of Shangri-La']
      }),
      dietary_requirements: [DietaryRequirement.new(name: 'Pescetarian')]
    )
    Presentation.create!(
      title: 'The Asymmetry and Antisymmetry of Syntax',
      room_use: RoomUse.includes(:room, :presentation_type, :institution).find_by(
        spina_conferences_rooms: { building: 'Lecture block', number: '2' },
        spina_conferences_presentation_types: { name: 'Talk' },
        spina_conferences_institutions: { name: 'University of Atlantis' }
      ),
      date: '2017-04-07',
      start_time: '10:00',
      abstract: 'Lorem ipsum',
      presenters: Delegate.where(first_name: 'Joe', last_name: 'Bloggs'),
      parts: presentation_parts
    )
  end
end
