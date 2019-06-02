
# Mounts the core application for this project
Padrino.mount('Firewah::App', :app_file => Padrino.root('app/app.rb')).to('/')
