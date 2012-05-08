require 'active_support/callbacks'

module Callmeback

  def self.included(base)
    $callmeback_methods = {}
    base.extend(ClassMethods)
  end

  def initialize
    super
    callback_binding
  end

  def callback_binding
    $callmeback_methods.each do |pst, vals|
      vals.each do |binded, callback|
        class_eval do
          define_method "wrapped_#{binded}" do
            prefix = 'callmeback'
            prefixed_binded = "#{prefix}_#{binded}"
            class_eval do
              define_callbacks prefixed_binded
              set_callback prefixed_binded, pst, callback
            end

            run_callbacks prefixed_binded do
              send "unwrapped_#{binded}"
            end
          end

          alias_method "unwrapped_#{binded}", binded
          alias_method binded, "wrapped_#{binded}"
        end
      end
    end
  end

  module ClassMethods
    class_eval do
      [:before, :after, :around].each do |method_name|
        define_method method_name do|hsh|
          $callmeback_methods[method_name] = hsh
        end
      end
    end
  end
end
