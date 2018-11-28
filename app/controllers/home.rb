Firewah::App.controllers :home do
  
  get :index, :map => '/' do
    fw = Fw.new("padlock.pd.o", "firewall name LAN_IN")

    @rules = fw.get_rules

    render 'index'
  end

   put :enable, :map => '/' do


  end
end
