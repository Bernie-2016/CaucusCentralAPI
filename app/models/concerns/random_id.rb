module Concerns
  module RandomId
    extend ActiveSupport::Concern

    included do
      before_create :generate_random_id

      #
      # IDs are designed to be able to be allocated independently by
      # different systems, and also to maintain sort order based on
      # created time. The format is:
      #
      #    timestamp(32 bits) | system (8-bits) | random (24-bits)
      #
      # timestamp is seconds since unix epoch
      # system is the system that generated the ID. 0 = browser, 128 = primary
      # app server, 129 = secondary app server, etc. random is 24 random bits
      # to allow multiple records to be created per second.
      #
      def generate_random_id
        return unless self.class.column_names.include?('id')
        self.id = SecureRandom.random_number(2**24)
        self.id = SecureRandom.random_number(2**24) while self.class.where(id: id).exists?
      end

      #
      # Javascript doesn't support integers larger than 48-bits, so convert
      # to string if we encounter larger integers during serialization.
      #
      # :nocov:
      def read_attribute_for_serialization(key)
        v = send(key)
        v = v.to_s if v.is_a?(Integer) && v >= (2**48)
        v
      end
      # :nocov:
    end
  end
end

#
# Encode integers as strings when Javascript would truncate them.
#
# :nocov:
class Numeric
  def as_json(_options = nil)
    if self >= 2**48
      to_s
    else
      self
    end
  end
end
# :nocov:
