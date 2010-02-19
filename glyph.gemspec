# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{glyph}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Fabio Cevasco"]
  s.date = %q{2010-02-19}
  s.default_executable = %q{glyph}
  s.description = %q{Glyph is a framework for structured document authoring.}
  s.email = %q{h3rald@h3rald.com}
  s.executables = ["glyph"]
  s.extra_rdoc_files = [
    "README.textile"
  ]
  s.files = [
    "README.textile",
     "Rakefile",
     "VERSION",
     "bin/glyph",
     "book/config.yml",
     "book/document.glyph",
     "book/output/html/glyph_handbook.html",
     "book/output/pdf/glyph_handbook.pdf",
     "book/snippets.yml",
     "book/styles/css3.css",
     "book/styles/default.css",
     "book/text/basic_usage.textile",
     "book/text/glyph_language.textile",
     "book/text/introduction.textile",
     "config.yml",
     "document.glyph",
     "glyph.gemspec",
     "lib/glyph.rb",
     "lib/glyph/commands.rb",
     "lib/glyph/config.rb",
     "lib/glyph/document.rb",
     "lib/glyph/glyph_language.rb",
     "lib/glyph/glyph_language.treetop",
     "lib/glyph/interpreter.rb",
     "lib/glyph/macro.rb",
     "lib/glyph/node.rb",
     "lib/glyph/system_extensions.rb",
     "macros/common.rb",
     "macros/filters.rb",
     "macros/html/block.rb",
     "macros/html/inline.rb",
     "macros/html/structure.rb",
     "spec/files/container.textile",
     "spec/files/document.glyph",
     "spec/files/document_with_toc.glyph",
     "spec/files/included.textile",
     "spec/files/ligature.jpg",
     "spec/files/markdown.markdown",
     "spec/files/test.sass",
     "spec/lib/commands_spec.rb",
     "spec/lib/config_spec.rb",
     "spec/lib/document_spec.rb",
     "spec/lib/glyph_spec.rb",
     "spec/lib/interpreter_spec.rb",
     "spec/lib/macro_spec.rb",
     "spec/lib/node_spec.rb",
     "spec/macros/filters_spec.rb",
     "spec/macros/macros_spec.rb",
     "spec/spec_helper.rb",
     "spec/tasks/generate_spec.rb",
     "spec/tasks/load_spec.rb",
     "spec/tasks/project_spec.rb",
     "styles/default.css",
     "tasks/generate.rake",
     "tasks/load.rake",
     "tasks/project.rake"
  ]
  s.homepage = %q{http://www.h3rald.com/glyph/}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Glyph -- A Ruby-powered Document Authoring Framework}
  s.test_files = [
    "spec/macros/filters_spec.rb",
     "spec/macros/macros_spec.rb",
     "spec/lib/interpreter_spec.rb",
     "spec/lib/commands_spec.rb",
     "spec/lib/node_spec.rb",
     "spec/lib/macro_spec.rb",
     "spec/lib/config_spec.rb",
     "spec/lib/glyph_spec.rb",
     "spec/lib/document_spec.rb",
     "spec/tasks/load_spec.rb",
     "spec/tasks/generate_spec.rb",
     "spec/tasks/project_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<gli>, [">= 0.3.1"])
      s.add_runtime_dependency(%q<extlib>, [">= 0.9.12"])
      s.add_runtime_dependency(%q<treetop>, [">= 0.4.3"])
      s.add_runtime_dependency(%q<rake>, [">= 0.8.7"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<gli>, [">= 0.3.1"])
      s.add_dependency(%q<extlib>, [">= 0.9.12"])
      s.add_dependency(%q<treetop>, [">= 0.4.3"])
      s.add_dependency(%q<rake>, [">= 0.8.7"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<gli>, [">= 0.3.1"])
    s.add_dependency(%q<extlib>, [">= 0.9.12"])
    s.add_dependency(%q<treetop>, [">= 0.4.3"])
    s.add_dependency(%q<rake>, [">= 0.8.7"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end

