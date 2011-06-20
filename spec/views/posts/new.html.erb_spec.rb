require 'spec_helper'

describe "posts/new.html.erb" do
  before(:each) do
    assign(:post, stub_model(Post,
      :comment => "MyString",
      :photo => "MyString",
      :user => nil
    ).as_new_record)
  end

  it "renders new post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => posts_path, :method => "post" do
      assert_select "input#post_comment", :name => "post[comment]"
      assert_select "input#post_photo", :name => "post[photo]"
      assert_select "input#post_user", :name => "post[user]"
    end
  end
end
