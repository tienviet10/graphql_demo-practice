module Queries
  module Users
    class GetUsers < Queries::BaseQuery
      # /users
      type [Types::Users::UserType], null: false

      def resolve
        User.all
      end
    end
  end
end
