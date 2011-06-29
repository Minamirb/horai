module Horai
  module SpecSupport
    module Controller
      def sign_in(user)
        request.session[:user_id] = user.id
        user
      end
    end
  end
end
