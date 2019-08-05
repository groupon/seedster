require "test_helper"
require "pathname"

class SeedsterTest < Minitest::Test
  def setup
    @file_manager = ::Seedster::FileManager.new(
      app_root: Pathname.new(".") # test double
    )
  end

  def test_that_it_has_a_version_number
    refute_nil ::Seedster::VERSION
    assert_equal '0.1.7', ::Seedster::VERSION
  end

  def test_file_manager_has_a_dump_dir
    expected = Pathname.new(File.join(
      ::Seedster::FileManager::TMP_DIR,
      ::Seedster::FileManager::DATA_DUMPS_DIR
    ))

    assert_equal expected, @file_manager.dump_dir
  end

  def test_file_manager_has_a_seed_file_dir
    expected = Pathname.new(File.join(
      ::Seedster::FileManager::TMP_DIR,
      ::Seedster::FileManager::SEED_FILE_DIR
    ))

    assert_equal expected, @file_manager.seed_file_dir
  end

  def test_that_file_manager_has_a_dump_file_name
    expected = "#{::Seedster::FileManager::SEEDSTER}-dump-latest.tar.gz"
    assert_equal expected, ::Seedster::FileManager.dump_file_name
  end

  def test_seedster_configuration_options
    configuration = ::Seedster::Configuration.new
    [
      :dump_host,
      :dump_database,
      :dump_username,
      :dump_password,
      :load_host,
      :load_database,
      :load_username,
      :load_password,
      :remote_host_path,
      :query_params,
      :ssh_user,
      :ssh_host,
      :tables,
      :skip_download
    ].each do |option|
      assert configuration.respond_to?(option)
    end
  end

  def test_configure_query_params
    user_id = 1 # could pass this as ENV['USER_ID'] from command line
    configure = Seedster.configure do |c|
      c.query_params = {user_id: user_id}
    end

    assert configure.is_a?(Hash)
    assert configure.has_key?(:user_id)
    assert_equal user_id, configure[:user_id]
  end
end
