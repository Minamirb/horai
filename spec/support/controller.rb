module Horai
  module SpecSupport
    module Controller
      OmniAuth.config.test_mode = true
      def sign_in_with_oauth(service = :facebook, user = nil)
        OmniAuth.config.add_mock(service,
                                 :credentials => {:token => Digest::SHA1.hexdigest(Time.now.to_f.to_s)},
                                 :extra => {:user_hash => {'name' => user.name}},
                                 :user_info => {:urls => ""})
        visit user_omniauth_callback_path(:action => service)
      end

      def sign_in(user)
        request.session[:user_id] = user.id
        user
      end
    end
  end
end
