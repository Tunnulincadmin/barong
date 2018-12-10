# frozen_string_literal: true

module API::V2
  module Entities
    class Document < Grape::Entity
      format_with(:iso_timestamp) { |d| d.utc.iso8601 }

      expose :upload, documentation: { type: 'String', desc: 'file url' }
      expose :doc_type, documentation: { type: 'String', desc: 'document type: passport, driver license' }
      expose :doc_number, documentation: { type: 'String', desc: 'document number: AB123123 type' }
      expose :doc_expire, documentation: { type: 'String', desc: 'expire date of uploaded documents' }
      expose :metadata, documentation: { type: 'String', desc: 'any additional stored data' }

      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
      end
    end
  end
end
