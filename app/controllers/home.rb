
Firewah::App.controllers :home do
  get :index, map: '/' do

    rule_hash = $REDIS.hgetall("rules")

    @rules = []
    rule_hash.each do |k,v|
    
      @rules << Oj::load(v)
    end

    render 'index'
  end

  get :save_backup, map: '/save_backup' do
    rule_hash = $REDIS.hgetall("rules")
  
    $REDIS.del("backup_rules")
    rule_hash.each do |k,v|
      $REDIS.hset("backup_rules", k, v)
    end
  
    redirect "/"
  end

  get :logout, map: '/logout' do
    session.delete('_login_firewah/app')
  
    redirect "/"
  end

  get :edit, map: '/edit/:id' do
    position = params[:id]

    @rule = Oj::load($REDIS.hget("rules", position))


    render 'edit'
  end

  post :update, map: '/update/:id' do
    position = params[:id]

    rule = Oj::load($REDIS.hget("rules", position))
 
    rule.description = params[:description]
    rule.enabled = params.has_key?(:enabled)
    rule.start_time = params[:start_time]
    rule.stop_time = params[:stop_time]

    msg = Message.new(:update_rule, rule)
    $QUEUE1 << Oj::dump(msg)

    redirect "/"
  end

  get :refresh, map: "/refresh" do
    msg = Message.new(:refresh)

    $QUEUE1 << Oj.dump(msg)
    logger.info "enqueuing request"
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
