module ControllerHelpers
  def login_user(user = instance_double('user'), scope = :user)
    current_user = "current_#{scope}".to_sym
    if user.blank?
      allow(request.env['warden']).to receive(:authenticate!)
        .and_throw(:warden, scope: scope)
      allow(controller).to receive(current_user).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(current_user).and_return(user)
    end
  end
end
