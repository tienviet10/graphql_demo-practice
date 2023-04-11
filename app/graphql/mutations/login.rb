class Mutations::Login < Mutations::BaseMutation
  argument :email, String, required: true
  argument :password, String, required: true

  field :user, Types::UserType, null: false
  field :errors, [String], null: false

  def resolve(email:, password:)
    user = User.find_by(email: email)
    if user&.authenticate(password)
      p "Success: Logged in"
      # user.token = user.to_sgid(expires_in: 12.hours, for: "graphql")
      # user
      {
        user: user,
        errors: [],
      }
    else
      p "Error: Invalid email or password"
      # raise GraphQL::ExecutionError.new("Invalid email or password")
      {
        user: {
          name: nil,
          email: nil,
        },
        errors: GraphQL::ExecutionError.new("Invalid email or password"),
      }
    end
  end
end
