defmodule Pocketex.Auth do
  @moduledoc """
  Wrapper functions around the Pocket auth API
  """

  @request_token_method_url   "https://getpocket.com/v3/oauth/request"
  @authorization_method_url   "https://getpocket.com/auth/authorize"
  @authorize_method_url       "https://getpocket.com/v3/oauth/authorize"
  @request_headers_json       [{"Content-Type", "application/json; charset=UTF-8"}, {"X-Accept", "application/json"}]

  @doc """
  Obtain a request token.
  To begin the Pocket authorization process, the application must obtain a
  request token from the Pocket servers by making a POST request.
  """

  def get_request_token(consumer_key, redirect_uri) do
    payload = ~s"""
    {
      "consumer_key":"#{consumer_key}",
      "redirect_uri":"#{redirect_uri}"
    }
    """

    HTTPoison.start
    HTTPoison.post!(@request_token_method_url, payload, @request_headers_json)
    |> Pocketex.Response.format_base
    |> Pocketex.Response.format_token_response
  end

  @doc """
  Returns the authorization URI for the Pocket API
  The web client integrating this wrapper needs to redirect there
  """
  def autorization_uri(request_token, callback_uri) do
    "#{@authorization_method_url}?request_token=#{request_token}&redirect_uri=#{URI.encode_www_form(callback_uri)}"
  end

  @doc """
  Makes an authorization request to convert the request token into a Pocket access token.
  """
  def authorize(consumer_key, request_token) do
    payload = ~s"""
    {
      "consumer_key":"#{consumer_key}",
      "code":"#{request_token}"
    }
    """

    HTTPoison.start
    HTTPoison.post!(@authorize_method_url, payload, @request_headers_json)
    |> Pocketex.Response.format_base
    |> Pocketex.Response.format_response
  end

end
