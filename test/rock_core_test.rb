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
end

