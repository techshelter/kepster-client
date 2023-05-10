# VCR.configure do |config|
#   config.cassette_library_dir     = 'spec/cassettes'

#   # - use { record: :all } to force refresh of cassettes
#   # config.default_cassette_options = { record: :all }
#   config.default_cassette_options = { record: :new_episodes }

#   config.hook_into :webmock

#   config.ignore_localhost = true

#   config.configure_rspec_metadata!
# end

# RSpec.configure do |config|
#   config.around(:each) do |example|
#     vcr_tag = example.metadata[:vcr]

#     if vcr_tag == false
#       VCR.turned_off(&example)
#     else
#       options = vcr_tag.is_a?(Hash) ? vcr_tag : {}
#       path_data = [example.metadata[:description]]
#       parent = example.example_group
#       p parent
#       path_data << parent.metadata[:description]
#       # while parent != RSpec::ExampleGroups
#       #   path_data << parent.metadata[:description]
#       #   parent = parent.parent
#       # end

#       name = path_data.map{|str| str.underscore.gsub(/\./,'').gsub(/[^\w\/]+/, '_').gsub(/\/$/, '')}.reverse.join("/")

#       VCR.use_cassette(name, options, &example)
#     end
#   end
# end