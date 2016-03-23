require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use!

class FakeTranslator

  def copy_argument
  end

  def execute_command(name)
  end

  def finish_command
  end

  def finish_document
  end

  def read_command(pattern = [])
  end

  def read_macro
  end

  def skip_argument
  end

  def write_text(text)
  end
end

$LOAD_PATH.unshift 'lib'
