module Mutations
  module Users
    class CreateUser < Mutations::BaseMutation
      argument :name, String, required: true
      argument :email, String, required: true

      field :user, Types::Users::UserType, null: false
      field :errors, [String], null: false

      def resolve(name:, email:)
        user = User.new(name: name, email: email)
        if user.save
          {
            user: user,
            errors: [],
          }
        else
          {
            user: nil,
            errors: user.errors.full_messages,
          }
        end
      end
    end
  end
end
