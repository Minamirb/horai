require 'spec_helper'

describe Post do
  it { should have_fields(:comment, :photo, :created_at, :updated_at) }
  it { should belong_to(:user) }
end
