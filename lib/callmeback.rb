require 'active_support/concern'
require 'active_support/callbacks'

module Callmeback
  extend ActiveSupport::Concern
  include ActiveSupport::Callbacks

  included do
    self.callmeback_methods = {}
  end

  def initialize(*args, &block)
    super(*args, &block)
    callback_binding
  end

  def callback_binding
    self.class.callmeback_methods.each do |pst, vals|
      vals.each do |binded, callback|
        class_eval do
          prefixed_binded = "callmeback_wrapped_#{binded}"
          define_method prefixed_binded do
            class_eval do
              define_callbacks prefixed_binded
              set_callback prefixed_binded, pst, callback
            end

            run_callbacks prefixed_binded do
              send "callmeback_unwrapped_#{binded}"
            end
          end

          alias_method "callmeback_unwrapped_#{binded}", binded
          alias_method binded, "callmeback_wrapped_#{binded}"
        end
      end
    end
  end

  module ClassMethods
    attr_accessor :callmeback_methods

    class_eval do
      [:before, :after, :around].each do |method_name|
        define_method method_name do |hsh|
          self.callmeback_methods[method_name] = hsh
        end
      end
    end
  end
end
