class GraphqlController < ApplicationController
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session
  # before_action :verify_jwt_token

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      # Query context goes here, for example:
      current_user: @current_user,
    }
    result = GraphqlFunDemoSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end

  def verify_jwt_token
    if params[:query].include?("login") || params[:query].include?("register")
      return
    end
    token = request.headers["Authorization"]&.split&.last
    decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: "HS256" })
    if decoded_token[0]["user_id"].present?
      @current_user = decoded_token[0]["user_id"]
    else
      raise GraphQL::ExecutionError, "Invalid token"
    end
    # You can do additional verification of the decoded token here, such as checking the expiration time or verifying the signature.

  rescue JWT::DecodeError, GraphQL::ExecutionError => e
    render json: { error: "Unauthorized", message: "Please login again" }, status: :unauthorized
  end
end
