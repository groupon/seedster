require "test_helper"

class SeedsterTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Seedster::VERSION
    assert_equal '0.1.5', ::Seedster::VERSION
  end

  def test_that_file_manager_has_a_dump_dir
    expected = File.join(
      ::Seedster::FileManager::TMP_DIR,
      ::Seedster::FileManager::DATA_DUMPS_DIR
    )
    assert_equal expected, ::Seedster::FileManager.dump_dir
  end

  ## TODO test the seed_file_dir, mock Rails.root

  def test_that_file_manager_has_a_dump_file_name
    expected = "#{::Seedster::FileManager::SEEDSTER}-dump-latest.tar.gz"
    assert_equal expected, ::Seedster::FileManager.dump_file_name
  end
end
