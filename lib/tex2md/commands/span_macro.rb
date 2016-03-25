require_relative 'command.rb'

module TeX2md
  class SpanMacro
    include Command

    def initialize(name)
      @name = name
      @pattern = /{/
    end

    def write(writer, _)
      writer.write "<span class='#{name}'>"
    end

    def transition(translator, _)
      translator.write_text("</span>")
      translator.copy_argument
    end

    def to_s
      "#{self.class}(#{name})"
    end
  end
end