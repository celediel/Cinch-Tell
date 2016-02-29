
# -*- encoding: utf-8 -*-
$LOAD_PATH.push('lib')
require 'cinch/plugins/tell/version'

Gem::Specification.new do |s|
  s.name     = 'Cinch-Tell'
  s.version  = Cinch::Tell::VERSION.dup
  s.date     = '2016-02-28'
  s.summary  = 'Cinch plugin to leave memos for people on IRC'
  s.email    = 'lilian.jonsdottir@gmail.com'
  s.homepage = 'https://github.com/lilyseki/Cinch-Tell'
  s.authors  = ['Lily J']
  s.license  = 'MIT'

  s.description = <<-EOF
Leave a message for someone on IRC who is not in the current
channel. They will recieve the message upon joining the channel
or changing their nick to the one that the message was left for.
Messages have a default lifespan of six months before they are
purged from the database.
EOF

  dependencies = [
    [:runtime, 'sequel', '~> 0'],
    [:runtime, 'time_diff', '~> 0'],
    [:runtime, 'facets', '~> 0']
  ]

  s.files         = Dir['**/*']
  s.test_files    = Dir['test/**/*'] + Dir['spec/**/*']
  s.executables   = Dir['bin/*'].map { |f| File.basename(f) }
  s.require_paths = ['lib']

  ## Make sure you can build the gem on older versions of RubyGems too:
  s.rubygems_version = '2.5.1'
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.specification_version = 3 if s.respond_to? :specification_version

  dependencies.each do |type, name, version|
    if s.respond_to?("add_#{type}_dependency")
      s.send("add_#{type}_dependency", name, version)
    else
      s.add_dependency(name, version)
    end
  end
end
