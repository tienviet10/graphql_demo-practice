require "rails_helper"

describe Mutations::CreateUser do
  def createAUser(name:, email:)
    described_class.new(object: nil, field: nil, context: {}).resolve(
      name: name, email: email,
    )
  end

  it "creates a new user" do
    result = createAUser(
      name: "Test User",
      email: "email@example.com",
    )

    user = result[:user]

    expect(user).to be_persisted
    expect(user.name).to eq("Test User")
    expect(user.email).to eq("email@example.com")
  end
end
