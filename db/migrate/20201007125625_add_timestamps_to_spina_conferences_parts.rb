# frozen_string_literal: true

class AddTimestampsToSpinaConferencesParts < ActiveRecord::Migration[6.0] # :nodoc:
  def change
    default = Time.zone.now
    add_timestamps :spina_conferences_parts, default: default
    change_column_default :spina_conferences_parts, :created_at, from: default, to: nil
    change_column_default :spina_conferences_parts, :updated_at, from: default, to: nil
  end
end
