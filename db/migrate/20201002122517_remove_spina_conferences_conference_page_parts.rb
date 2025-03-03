# frozen_string_literal: true

class RemoveSpinaConferencesConferencePageParts < ActiveRecord::Migration[6.0] # :nodoc:
  def change
    drop_table :spina_conferences_conference_page_parts do |t|
      t.references :conference_page, foreign_key: { to_table: :spina_pages, on_delete: :cascade },
                                     index: { name: 'index_spina_conferences_parts_on_page_id' }
      t.references :conference_page_partable, polymorphic: true,
                                              index: { name: 'index_spina_conferences_parts_on_partable_type_and_partable_id' }

      t.timestamps
    end
  end
end
