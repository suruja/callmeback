require 'active_support/concern'
require 'active_support/callbacks'

module Callmeback
  extend ActiveSupport::Concern
  include ActiveSupport::Callbacks

  included do
    # Initialize the callmeback methods and method index
    self.callmeback_methods = {}
    self.callmeback_method_index = 0
  end

  def initialize(*args, &block)
    super(*args, &block)

    # Overwrite the initialize method to perform the defined callbacks binding
    callback_binding
  end

  def callback_binding
    self.class.callmeback_methods.each do |callback_prefix, callback_array|
      callback_array.each do |callback_hash|
        callback_hash.each do |callback_key, callbacks|

          callbacks = [callbacks].flatten

          if callback_key.is_a?(Regexp)
            binded_methods = methods.select{|m| m =~ callback_key}
          else
            binded_methods = [callback_key].flatten
          end

          binded_methods.each do |binded|
            callbacks.each do |callback|

              binded_suffix = "method_#{self.class.callmeback_method_index}"
              self.class.callmeback_method_index += 1

              prefixed_wrapped_binded = "callmeback_wrapped_#{binded_suffix}"
              prefixed_unwrapped_binded = "callmeback_unwrapped_#{binded_suffix}"

              class_eval do
                define_method prefixed_wrapped_binded do
                  class_eval do
                    define_callbacks prefixed_wrapped_binded
                    set_callback prefixed_wrapped_binded, callback_prefix, callback
                  end

                  run_callbacks prefixed_wrapped_binded do
                    send prefixed_unwrapped_binded
                  end
                end

                alias_method prefixed_unwrapped_binded, binded
                alias_method binded, prefixed_wrapped_binded
              end
            end
          end
        end
      end
    end
  end

  module ClassMethods
    attr_accessor :callmeback_methods
    attr_accessor :callmeback_method_index

    [:before, :after, :around].each do |callback_prefix|
      define_method callback_prefix do |arg, &block|
        self.callmeback_methods[callback_prefix] ||= []
        arg = {arg => block} if block.is_a?(Proc)
        self.callmeback_methods[callback_prefix] << arg
      end
    end
  end
end
