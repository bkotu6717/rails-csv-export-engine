module Exporter
  class Engine < ::Rails::Engine
    isolate_namespace Exporter
    paths["lib"] = "lib"
  end
end
