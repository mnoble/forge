require "forge/version"

module Forge
  class ForgeError < StandardError
  end

  class DuplicateFactoryError < ForgeError
  end

  class MissingFactoryError < ForgeError
  end

  class << self
    attr_accessor :registry
  end

  def self.reset!
    @registry = {}
    @sequence = Sequence.new
  end

  def self.sequence
    @sequence ||= Sequence.new
  end

  def self.define(name, klass, &block)
    @registry ||= {}
    raise DuplicateFactoryError if @registry[name]
    @registry[name] = Definition.new(klass, &block)
  end

  def self.build(name, attrs={})
    raise MissingFactoryError unless @registry[name]
    @registry[name].build(attrs)
  end

  def self.create(name, attrs={})
    raise MissingFactoryError unless @registry[name]
    @registry[name].create(attrs)
  end

  class Sequence
    def initialize
      @n = 1
    end

    def value
      @n
    end

    def next 
      @n += 1
    end
  end

  class Definition
    attr_accessor :klass, :block

    def initialize(klass, &block)
      @klass = klass
      @block = block
    end

    def build(attrs={})
      instance = @klass.new.tap { |o| @block.call(o) }
      attrs.each { |k,v| instance.public_send(:"#{k}=", v) }
      instance
    end

    def create(attrs={})
      build(attrs).tap { |o| o.save }
    end
  end

  module DSL
    def define(*args, &block)
      Forge.define(*args, &block)
    end

    def build(*args)
      Forge.build(*args)
    end

    alias_method :forge, :build

    def create(*args)
      Forge.create(*args)
    end
  end
end
