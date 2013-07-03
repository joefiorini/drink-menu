module Forwardable
  FORWARDABLE_VERSION = "1.1.0"

  @debug = nil
  class << self
    attr_accessor :debug
  end

  # Takes a hash as its argument.  The key is a symbol or an array of
  # symbols.  These symbols correspond to method names.  The value is
  # the accessor to which the methods will be delegated.
  #
  # :call-seq:
  #    delegate method => accessor
  #    delegate [method, method, ...] => accessor
  #
  def instance_delegate(hash)
    hash.each{ |methods, accessor|
      methods = [methods] unless methods.respond_to?(:each)
      methods.each{ |method|
        def_instance_delegator(accessor, method)
      }
    }
  end

  #
  # Shortcut for defining multiple delegator methods, but with no
  # provision for using a different name.  The following two code
  # samples have the same effect:
  #
  #   def_delegators :@records, :size, :<<, :map
  #
  #   def_delegator :@records, :size
  #   def_delegator :@records, :<<
  #   def_delegator :@records, :map
  #
  def def_instance_delegators(accessor, *methods)
    methods.delete("__send__")
    methods.delete("__id__")
    for method in methods
      def_instance_delegator(accessor, method)
    end
  end

  def def_instance_delegator(accessor, method, ali = method)
    accessor = accessor.id2name if accessor.kind_of?(Integer)
    method = method.id2name if method.kind_of?(Integer)
    ali = ali.id2name if ali.kind_of?(Integer)
    activity = Proc.new do
      define_method("#{ali}") do |*args, &block|
        begin
          instance_variable_get(accessor).__send__(method, *args, &block)
        rescue Exception
          $@.delete_if{|s| %r"#{Regexp.quote(__FILE__)}"o =~ s} unless Forwardable::debug
          Kernel::raise
        end
      end
    end

    # If it's not a class or module, it's an instance
    begin
      module_eval(&activity)
    rescue
      instance_eval(&activity)
    end
  end

  alias delegate instance_delegate
  alias def_delegators def_instance_delegators
  alias def_delegator def_instance_delegator
end

module SingleForwardable
  # Takes a hash as its argument.  The key is a symbol or an array of
  # symbols.  These symbols correspond to method names.  The value is
  # the accessor to which the methods will be delegated.
  #
  # :call-seq:
  #    delegate method => accessor
  #    delegate [method, method, ...] => accessor
  #
  def single_delegate(hash)
    hash.each{ |methods, accessor|
      methods = [methods] unless methods.respond_to?(:each)
      methods.each{ |method|
        def_single_delegator(accessor, method)
      }
    }
  end

  #
  # Shortcut for defining multiple delegator methods, but with no
  # provision for using a different name.  The following two code
  # samples have the same effect:
  #
  #   def_delegators :@records, :size, :<<, :map
  #
  #   def_delegator :@records, :size
  #   def_delegator :@records, :<<
  #   def_delegator :@records, :map
  #
  def def_single_delegators(accessor, *methods)
    methods.delete("__send__")
    methods.delete("__id__")
    for method in methods
      def_single_delegator(accessor, method)
    end
  end

  #
  # Defines a method _method_ which delegates to _obj_ (i.e. it calls
  # the method of the same name in _obj_).  If _new_name_ is
  # provided, it is used as the name for the delegate method.
  #
  def def_single_delegator(accessor, method, ali = method)
    instance_eval do
      define_method("#{ali}") do |*args, &block|
        begin
          instance_variable_get(accessor).__send__(method, *args, &block)
        rescue Exception
          $@.delete_if{|s| %r"#{Regexp.quote(__FILE__)}"o =~ s} unless Forwardable::debug
          ::Kernel::raise
        end
      end
    end
  end

  alias delegate single_delegate
  alias def_delegators def_single_delegators
  alias def_delegator def_single_delegator
end
