class Mutations::Registration < Mutations::BaseMutation
  argument :name, String, required: true
  argument :email, String, required: true
  argument :password, String, required: true

  field :user, Types::UserType, null: false
  field :errors, [String], null: false

  def resolve(**kwargs)
    user = User.new(kwargs)
    if user.save
      # user.token = user.to_sgid(expires_in: 12.hours, for: 'graphql')
      # user
      {
        user: user,
        errors: [],
      }
    else
      {
        user: {
          name: nil,
          email: nil,
        },
        errors: GraphQL::ExecutionError.new("Register failed."),
      }
    end
  end
end
