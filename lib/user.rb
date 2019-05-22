module User
  extend self

  # db model must have authenticate method which should response with credentials object on
  # the calls of { :email => 'a@b', :password => 'abc' } to authenticate by email and password
  # or { :id => 42 } to restore credentials from id saved in session or another persistance storage
  def authenticate(credentials)
    case
    when credentials[:email] && credentials[:password]
      target = all.find{ |resource| resource.id.to_s == credentials[:email] }
      (target && target.pw == credentials[:password]) ? target : nil
    when credentials.has_key?(:id)
      all.find{ |resource| resource.id == credentials[:id] }
    else
      false
    end
  end

  # example collection of users
  def all
    @all = [
      OpenStruct.new(id: :parent, pw: "test", name: "Bennett Parent" )
    ]
  end
end