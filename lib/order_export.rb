require 'spree_core'
require 'order_export_hooks'

module OrderExport
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
      
      # fix broken translation on core reports
      I18n.load_path << Spree::OrderExport::Engine.config.paths["config/locales"].first
      I18n.locale = I18n.default_locale
      I18n.reload!
  
      Spree::Admin::ReportsController::AVAILABLE_REPORTS.merge!({:order_export => {:name => "Order Export", :description => "Order Export Description"}})
      Spree::Admin::ReportsController.send(:require, RUBY_VERSION.split('.')[1].to_i > 8 ? 'csv' : 'fastercsv')
      Spree::Admin::ReportsController.send(:include, OrderExport::ReportsControllerExt)
    end

    config.to_prepare &method(:activate).to_proc
  end
end

