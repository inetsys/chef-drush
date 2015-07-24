if defined?(ChefSpec)
    def create_drush_settings(resource_name)
        ChefSpec::Matchers::ResourceMatcher.new(:drush_settings, :create, resource_name)
    end
end