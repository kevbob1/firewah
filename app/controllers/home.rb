# frozen_string_literal: true

Firewah::App.controllers :home do
  get :index, map: '/' do

    rule_hash = $REDIS.hgetall("rules")

    @rules = []
    rule_hash.each do |k,v|
    
      @rules << YAML.load(v)
    end


    render 'index'
  end

  get :edit, map: '/edit/:id' do
    position = params[:id]

    @rule = YAML.load($REDIS.hget("rules", position))


    render 'edit'
  end

  post :update, map: '/update/:id' do
    position = params[:id]

    rule = YAML.load($REDIS.hget("rules", position))
 
    rule.description = params[:description]
    rule.enabled = params.has_key?(:enabled)
    rule.start_time = params[:start_time]
    rule.stop_time = params[:stop_time]
     
    $REDIS.hset("rules", position, rule.to_yaml)

    redirect "/"
  end

  get :refresh, map: "/refresh" do

    fw = Fw.new('padlock.pd.o', 'firewall name LAN_IN')

    rules = fw.get_rules

    rules.each do |rule| 
      $REDIS.hset("rules", rule.position, rule.to_yaml)
    end

    redirect "/"
  end

  get :csrf_token, :map => '/csrf_token', :provides => :json do
    logger.debug 'Retrieving csrf_token'
    result = {
        :csrf => session[:csrf]
    }
    JSON.pretty_generate result
  end
end
