Gem::Specification.new do |s|
  s.name = 'wtth'
  s.version = '1.0.0'

  s.authors = ['Matthew Donoughe']
  s.date = '2009-09-26'
  s.description = 'Welcome to the Horde is a program that tweets when people join the zombie horde(in humans vs. zombies).'
  s.email = 'mdonoughe@gmail.com'
  s.extra_rdoc_files = ['LICENSE', 'README.markdown']
  s.files = ['README.markdown', 'bin/wtth', 'lib/wtth/config.rb', 'lib/wtth/hvzsource.rb', 'lib/wtth/twitter.rb']
  s.executable = 'wtth'
  s.has_rdoc = true
  s.rdoc_options = ['--main', 'README.markdown']
  s.homepage = 'http://github.com/mdonoughe/wtth'
  s.require_paths = ['lib']
  s.summary = s.description

  s.add_dependency('nokogiri', '>= 1.0.0')
  s.add_dependency('twitter', '>= 0.5.0')
end
