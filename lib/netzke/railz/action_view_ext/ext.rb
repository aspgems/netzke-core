module Netzke
  module Railz
    module ActionViewExt
      # Implementation of Ext-specific helpers
      module Ext #:nodoc:

        protected

          def netzke_ext_css_include(params)
            # ExtJS base
            theme = params[:theme] || params[:ext_theme]
            theme = theme.present? ? "ext-all-#{theme.to_s}" : 'ext-all'
            res = ["#{Netzke::Core.ext_uri}/resources/css/#{theme}"]

            # Netzke-related dynamic css
            res << "/netzke/ext"

            res += Netzke::Core.external_ext_css

            stylesheet_link_tag(*res)
          end

          def netzke_ext_js_include(params)
            res = []

            # ExtJS
            res << (Netzke::Core.js_debug ? "#{Netzke::Core.ext_uri}/ext-all-debug" : "#{Netzke::Core.ext_uri}/ext-all")

            # ExtJS 3 compatibility layer
            if compat_uri = Netzke::Core.ext3_compat_uri
              res << "#{compat_uri}/ext3-core-compat"
              res << "#{compat_uri}/ext3-compat"
            end

            # Ext I18n
            res << "#{Netzke::Core.ext_uri}/locale/ext-lang-#{I18n.locale}" if I18n.locale != :en

            # Netzke-related dynamic JavaScript
            res << "/netzke/ext"

            javascript_include_tag(*res)
          end

          def netzke_ext_js(params)
            res = []
            res << content_for(:netzke_js_classes)

            res << "Ext.onReady(function(){"
            res << content_for(:netzke_on_ready)
            res << "});"

            javascript_tag(res.join("\n"))
          end

          # (Experimental) Embeds a "pure" (non-Netzke) Ext component into the view, e.g.:
          #     <%= ext :my_panel, :xtype => :panel, :html => "Simple Panel"
          def ext(name, config = {}) #:doc:
            comp = Netzke::ExtComponent.new(name, config)
            content_for :netzke_on_ready, raw("#{comp.js_component_render}")
            raw(comp.js_component_html)
          end

      end
    end
  end
end
