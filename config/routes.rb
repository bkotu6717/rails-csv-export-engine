Exporter::Engine.routes.draw do
  get '/:entity' => "export#generate", as: :generate_export_file
end
