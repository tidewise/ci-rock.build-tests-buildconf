require_relative 'test_helper'

describe "rock.core package set configuration" do
    it "builds the test folder if tests are enabled" do
        # NOTE: all tests are assumed to be enabled by default on the build tests
        # workspaces
        assert system("which", "rock-core-enable-tests-successful")
    end

    it "builds the test folder if tests are enabled" do
        # NOTE: tests for this package must be disabled in the autoproj
        # workspace. Use the buildconf seed config.
        refute system("which", "rock-core-tests-built-if-enabled")
    end

    it 'adds the minitest-junit dependency on CMake packages '\
       'with Ruby bindings if the tests are enabled' do
        output = `#{File.join(ENV['AUTOPROJ_CURRENT_ROOT'], '.autoproj', 'bin', 'autoproj')} show rock_ruby_test_writes_junit_report`
        assert_match(/minitest-junit/, output)
    end

    it 'does not add the minitest-junit dependency on CMake packages '\
       'with Ruby bindings if the tests are disabled' do
        output = `#{File.join(ENV['AUTOPROJ_CURRENT_ROOT'], '.autoproj', 'bin', 'autoproj')} show does_not_add_minitest_junit_dependency_on_disabled_tests`
        refute_match(/minitest-junit/, output)
    end
end

