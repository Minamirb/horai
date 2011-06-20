require 'spec_helper'

describe "posts/show.html.erb" do
  before(:each) do
    @post = assign(:post, stub_model(Post,
      :comment => "Comment",
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Comment/)
  end
end
