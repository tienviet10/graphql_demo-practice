module Mutations
  module Users
    class Login < Mutations::BaseMutation
      argument :email, String, required: true
      argument :password, String, required: true

      field :user, Types::Users::UserType, null: false
      field :token, String, null: false
      field :errors, [String], null: false

      def resolve(email:, password:)
        user = User.find_by(email: email)
        if user&.authenticate(password)
          p user.id
          token = JWT.encode({ user_id: user.id, exp: 7.days.from_now.to_i }, Rails.application.secrets.secret_key_base)
          p "Success: Logged in"
          p token
          {
            user: user,
            token: token,
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
            token: nil,
            errors: GraphQL::ExecutionError.new("Invalid email or password"),
          }
        end
      end
    end
  end
end
