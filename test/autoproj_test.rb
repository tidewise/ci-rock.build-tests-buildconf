require_relative 'test_helper'

describe "Autoproj" do
    it "checked out make-based package test dependencies on checkout" do
        assert File.directory?(package_source_dir('build_tests',
            'build_tests/autoproj_tests/checkout_of_test_dependencies_make-dep'))
    end

    it "checked out ruby-based package test dependencies on checkout" do
        assert File.directory?(package_source_dir('build_tests',
            'build_tests/autoproj_tests/checkout_of_test_dependencies_ruby-dep'))
    end
end
