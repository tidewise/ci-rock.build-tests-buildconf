$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "minitest/autorun"
require "minitest/spec"
require 'utilrb/pkgconfig'

module Helpers
    def resolve_library(package_name)
        pkg = Utilrb::PkgConfig.get(package_name)
        expected_libname =  "lib#{package_name}.so"
        matching_dir = pkg.library_dirs.find do |path|
            File.file?(File.join(path, expected_libname))
        end
        if matching_dir
            File.join(matching_dir, expected_libname)
        else
            raise ArgumentError, "could not find lib#{package_name}.so in\n  #{pkg.library_dirs.join("\n  ")}"
        end
    end

    def each_cxx_linked_library(path)
        return enum_for(__method__, path) if !block_given?

        IO.popen(["ldd", path]).each_line do |line|
            if line.chomp =~ /^\s*(.*)\s=>\s(.*) \(0x[0-9a-f]+\)$/
                yield($1, $2)
            else
                puts "NOT MATCHING #{line}"
            end
        end
    end

    def assert_cxx_library_is_linked_to(package, linked_to)
        expected = resolve_library(linked_to)
        library  = resolve_library(package)

        ldd_results = each_cxx_linked_library(library)
        matching_dependency = ldd_results.find do |basename, path|
            path == expected
        end
        if !matching_dependency
            flunk("#{library} (resolved as #{library}) does not seem to be linked to #{linked_to} (resolved as #{expected}). Found:\n  #{ldd_results.map { |a, b| "#{a} => #{b}" }.join("\n  ")}")
        end
    end

    def package_source_dir(*package)
        File.join(ENV['AUTOPROJ_CURRENT_ROOT'], *package)
    end
end

Minitest::Test.include Helpers
