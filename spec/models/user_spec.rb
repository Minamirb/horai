require 'spec_helper'

describe User do
  it "should respond to posts" do
    user = User.new
    user.should respond_to(:posts)
  end
end
