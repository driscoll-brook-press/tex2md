require_relative 'command.rb'

module DBP::BookCompiler::MarkdownToTex
  class FinishDocument
    include Command

    def initialize
      @name = nil
    end

    def transition(translator, _)
      translator.finish_document
    end

    def to_s
      self.class.to_s
    end
  end
end