require "rails_helper"

describe Mutations::CreatePost do
  let!(:user) { create(:user, name: "Alex", email: "a@gmail.com") }

  def createAPost(title:, body:)
    described_class.new(object: nil, field: nil, context: {}).resolve(
      title: title, body: body,
    )
  end

  it "creates a new post" do
    result = createAPost(
      title: "Here is my title!",
      body: "Here is my body!",
    )

    post = result[:post]
    p result
    expect(post).to be_persisted
    expect(post.title).to eq("Here is my title!")
    expect(post.body).to eq("Here is my body!")
  end
end
