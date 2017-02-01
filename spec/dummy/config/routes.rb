Rails.application.routes.draw do

  mount Exporter::Engine => "/exporter"
end
