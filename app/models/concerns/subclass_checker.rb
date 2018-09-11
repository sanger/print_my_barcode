# frozen_string_literal: true

module SubclassChecker
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def has_subclasses(*classes)
      options = classes.extract_options!
      classes.each do |klass|
        object_type = klass.to_s.capitalize
        object_type << to_s.capitalize if options[:suffix]
        define_method "#{klass}?" do
          type == object_type
        end
      end
    end
  end
end
