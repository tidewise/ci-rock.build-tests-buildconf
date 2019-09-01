require_relative 'test_helper'
require 'orogen'

describe "library-orogen interactions" do
    describe "explicit c++xx standard" do
        it "imports C++11 headers successfully if the pkg-config file specifies the -std= flag" do
            assert Utilrb::PkgConfig.has_package?('orogen-project-cxx11_dependency')
        end
    end
end

describe "m-type generation" do
    before do
        @loader = OroGen::Loaders::PkgConfig.new 'gnulinux'
        typekit = @loader.typekit_model_from_name 'm_type_generation'
        @m_type = typekit.registry.get '/m_type_generation/Containing_m'
    end

    it "sets up the opaque-related metadata on the m-type" do
        assert_equal ['1'], @m_type.metadata.get('orogen:m_type')
        assert_equal ['/m_type_generation/Containing'], @m_type.metadata.get('orogen:intermediate_for')
    end

    it "sets up the m-type include and path properly" do
        assert_equal ["m_type_generation:m_type_generation/m_types/m_type_generation_Containing.hpp"],
            @m_type.metadata.get('orogen_include')
    end
end

