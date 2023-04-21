module Types
  class QueryType < Types::BaseObject
    # # /users
    # field :users, [Types::Users::UserType], null: false

    # def users
    #   User.all
    # end

    field :users, resolver: Queries::Users::GetUsers

    # # /user/:id
    # field :user, Types::Users::UserType, null: false do
    #   argument :id, ID, required: true
    # end

    # def user(id:)
    #   User.find(id)
    # end

  end
end
