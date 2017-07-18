require_relative 'test_helper'

describe "library-orogen interactions" do
    describe "explicit c++xx standard" do
        it "imports C++11 headers successfully if the pkg-config file specifies the -std= flag" do
            assert Utilrb::PkgConfig.has_package?('orogen-project-cxx11_dependency')
        end
    end
end

