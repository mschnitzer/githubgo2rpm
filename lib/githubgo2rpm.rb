require 'net/http'
require 'json'
require 'fileutils'

module GithubGo2Rpm
  class Repository
    attr_reader :details

    def initialize(repository)
      @repo = repository
      fetch
    end

    private

    def fetch
      uri = URI("https://api.github.com/repos/#{@repo}")
      @details = JSON.parse(Net::HTTP.get(uri))
    end
  end

  class OBSPackage 
    def initialize(repository)
      @repo = Repository.new(repository)
    end

    def create_package(path, create_dir = true)
      path += '/' if path[-1] != '/'

      package_name = "golang-github-#{@repo.details['owner']['login']}-#{@repo.details['name']}"

      if create_dir
        directory = "#{path}#{package_name}"
        FileUtils.mkdir(directory)
      else
        directory = path
      end

      spec_file_name = "#{package_name}.spec"

      File.open("#{directory}/#{spec_file_name}", 'w+') { |file| file.write(generate_spec) }
      File.open("#{directory}/_service", 'w+') { |file| file.write(generate_service) }
    end

    def generate_spec
      username = @repo.details['owner']['login']
      library_name = @repo.details['name']
      
      summary = @repo.details['description']
      summary = summary[0..-2] if summary[-1] == '.' || summary[-1] == '!'

      description = @repo.details['description']
      description = description[0..-2] if description[-1] == '.' || description[-1] == '!'

      template = File.open("#{File.dirname(File.dirname(__FILE__))}/templates/golang-spec-file.template").read
      template.gsub!('%LIBRARY_NAME%', library_name)
      template.gsub!('%LIBRARY_USERNAME%', username)
      template.gsub!('%YEAR%', Time.now.year.to_s)
      template.gsub!('%LIBRARY_SUMMARY%', summary)
      template.gsub!('%LIBRARY_DESCRIPTION%', description)
      template.gsub!('%LIBRARY_LICENSE%', 'MIT')
    end

    def generate_service
      username = @repo.details['owner']['login']
      library_name = @repo.details['name']
      
      template = File.open("#{File.dirname(File.dirname(__FILE__))}/templates/_service.template").read
      template.gsub!('%LIBRARY_NAME%', library_name)
      template.gsub!('%LIBRARY_USERNAME%', username)
    end
  end
end
