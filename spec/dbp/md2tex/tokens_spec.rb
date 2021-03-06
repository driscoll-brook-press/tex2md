require_relative '_helper'
require 'dbp/book_compiler/markdown_to_tex/translator'

module DBP::BookCompiler::MarkdownToTex
  describe Translator, 'token patterns' do
    let(:scanner) { StringScanner.new(input) }
    let(:pattern) { Translator::TOKENS[subject] }

    before do
      scanner.scan(pattern)
    end

    describe :comment do
      subject { :comment }

      describe 'against a comment' do
        let(:content) { '                   some comment            ' }
        let(:comment) { "<!--#{content}-->" }
        let(:input) { "#{comment}additional text" }

        it 'matches the comment' do
          _(scanner.matched).must_equal comment
        end

        it 'captures the stripped comment content in capture group 1' do
          _(scanner[1]).must_equal content.strip
        end
      end
    end

    describe :emphasis do
      subject { :emphasis }

      %w(** _).each do |delimiter|
        describe "against the #{delimiter} delimiter" do
          let(:input) { "#{delimiter}additional text" }

          it 'matches the delimiter' do
            _(scanner.matched).must_equal delimiter
          end
        end
      end
    end

    describe :end_tag do
      subject { :end_tag }

      describe 'against an end tag' do
        let(:tag_name) { 'monkeymonkey' }
        let(:tag) { "</#{tag_name}               >" }
        let(:input) { "#{tag}additional text" }

        it 'matches the tag' do
          _(scanner.matched).must_equal tag
        end

        it 'captures the tag name in capture group 1' do
          _(scanner[1]).must_equal tag_name
        end
      end
    end

    describe :open_tag do
      subject { :open_tag }

      describe 'against an open tag with a class attribute' do
        let(:class_attribute_value) { '     monkey     ' }
        let(:tag_name) { 'mytag' }
        let(:tag) { %Q{<#{tag_name}                    class    =        "#{class_attribute_value}"              >} }
        let(:input) { "#{tag}additional text" }

        it 'matches the tag' do
          _(scanner.matched).must_equal tag
        end

        it 'captures the tag name in capture group 1' do
          _(scanner[1]).must_equal tag_name
        end

        it 'captures the stripped class attribute value in capture group 2' do
          _(scanner[2]).must_equal class_attribute_value.strip
        end
      end
    end

    describe :text do
      subject { :text }

      describe 'against a string with no operator characters' do
        let(:input) { 'a string with no operator characters!@#$%&()-+=' }

        it 'matches the entire string' do
          _(scanner.matched).must_equal input
        end
      end

      %w{< * _}.each do |c|
        describe "against text followed by an operator character #{c}" do
          let(:text) { 'before the operator character' }
          let(:input) { "#{text}#{c}after the operator character" }

          it 'matches the text before the operator character' do
            _(scanner.matched).must_equal text
          end
        end
      end
    end

    describe :void_tag do
      subject { :void_tag }

      describe 'against a void tag' do
        let(:tag_name) { 'mytag' }
        let(:tag) { "<#{tag_name}                    />" }
        let(:input) { "#{tag}additional text" }

        it 'matches the tag' do
          _(scanner.matched).must_equal tag
        end

        it 'captures the tag name in capture group 1' do
          _(scanner[1]).must_equal tag_name
        end
      end
    end

    describe :yaml_header do
      subject { :yaml_header }

      let(:yaml) do
        [
            '---           ',
            'key1: value1',
            'key2: value2',
            '...',
        ].join($/)
      end

      let(:input) { "#{yaml}additional text"}

      it 'matches a YAML document' do
        _(scanner.matched).must_equal yaml
      end
    end
  end
end
