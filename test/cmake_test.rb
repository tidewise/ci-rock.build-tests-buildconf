require_relative 'test_helper'

describe "CMake macros" do
    describe "rock_activate_cxx11" do
        it "is built" do
            assert Utilrb::PkgConfig.has_package?('rock_activate_cxx11')
        end
        it "exports the -std=c++11 flag" do
            assert Utilrb::PkgConfig.get('rock_activate_cxx11').raw_cflags.include?('-std=c++11')
        end
        it "does not export the -std=c++11 flag on non explicitely activated C++11 packages" do
            refute Utilrb::PkgConfig.get('plain_package').raw_cflags.include?('-std=c++11')
        end
    end

    describe 'rock_library' do
        describe 'header-only libraries' do
            it "installs the library's pkg-config file" do
                assert Utilrb::PkgConfig.get('headers_only_library')
            end

            it "plays well with the C++ standard activation feature" do
                assert Utilrb::PkgConfig.get('cxx11_headers_only_library').raw_cflags.include?('-std=c++11')
            end
        end

        describe "pkg-config dependencies" do
            describe "DEPS_PKGCONFIG" do
                it "links to the dependent library" do
                    assert_cxx_library_is_linked_to 'rock_library_deps_pkgconfig',
                        'plain_package'
                end
                it "lists the dependent library in the Requires: section of the pkg-config file" do
                    assert_equal ['plain_package'], Utilrb::PkgConfig.get('rock_library_deps_pkgconfig').
                        requires.map(&:name)
                end
            end

            describe "rock_add_public_dependencies" do
                it "links to both public and private dependencies" do
                    assert_cxx_library_is_linked_to 'rock_library_add_public_dependencies',
                        'plain_package'
                    assert_cxx_library_is_linked_to 'rock_library_add_public_dependencies',
                        'another_plain_package'
                end
                it "lists only the public dependencies in the Requires: section of the pkg-config file" do
                    assert_equal ['plain_package'], Utilrb::PkgConfig.get('rock_library_add_public_dependencies').
                        requires.map(&:name)
                end
            end

            describe "rock_no_public_dependencies" do
                it "links to the dependencies" do
                    assert_cxx_library_is_linked_to 'rock_library_no_public_dependencies',
                        'plain_package'
                end
                it "does not list any of the dependencies in the Requires: section of the pkg-config file" do
                    assert_equal [], Utilrb::PkgConfig.get('rock_library_no_public_dependencies').
                        requires
                end
            end

            describe "ROCK_PUBLIC_CXX_STANDARD" do
                it "builds with the C++11 standard" do
                    # There is C++11-specific code in the package, just check
                    # that it has built
                    assert Utilrb::PkgConfig.has_package?('var_ROCK_PUBLIC_CXX_STANDARD')
                end

                it "exports the value of ROCK_PUBLIC_CXX_STANDARD as a -std= argument in the pkg-config file" do
                    assert Utilrb::PkgConfig.get('var_ROCK_PUBLIC_CXX_STANDARD').raw_cflags.include?('-std=c++98')
                    refute Utilrb::PkgConfig.get('var_ROCK_PUBLIC_CXX_STANDARD').raw_cflags.include?('-std=c++11')
                end
            end
        end
    end
end
