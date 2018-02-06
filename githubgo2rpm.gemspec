Gem::Specification.new do |s|
  s.name        = 'githubgo2rpm'
  s.version     = '0.0.1'
  s.date        = '2018-02-06'
  s.summary     = "Convert golang libraries on github to spec files"
  s.description = "This program converts golang libraries from github to a rpm spec file."
  s.authors     = ["Manuel Schnitzer"]
  s.email       = 'webmaster@mschnitzer.de'
  s.files       = ["lib/githubgo2rpm.rb", "bin/githubgo2rpm", "templates/golang-spec-file.template", "templates/_service.template"]
  s.executables << "githubgo2rpm"
  s.homepage    = 'https://github.com/mschnitzer/githubgo2rpm'
  s.license     = 'MIT'
end
