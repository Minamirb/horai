require 'spec_helper'

describe "posts/edit.html.erb" do
  before(:each) do
    @post = assign(:post, stub_model(Post,
      :comment => "MyString",
      :photo => "MyString",
      :user => nil
    ))
  end

  it "renders the edit post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => posts_path(@post), :method => "post" do
      assert_select "input#post_comment", :name => "post[comment]"
      assert_select "input#post_photo", :name => "post[photo]"
      assert_select "input#post_user", :name => "post[user]"
    end
  end
end
