defmodule Pocketex.Response do
  @moduledoc """
  Wrapper around Pocket API responses
  """

  @doc """
  Generic wrapper around Pocket API responses
  """
  def format_base(response) do
    %{
      headers:      Enum.into(response.headers, %{}),
      body:         response.body,
      status_code:  response.status_code
    }
  end

  @doc """
  Wrapper around the Pocket API successful response for request token
  """
  def format(:request_token, response) do
    payload = Poison.Parser.parse!(response.body)
    {
      :ok,
      Dict.merge(Pocketex.Response.format_base(response),
                %{
                  status:         response.headers["Status"],
                  request_token:  payload["code"]
                })
    }
  end

  @doc """
  Formats the Pocket A{O} response for consumption
  Checks to see if the response is valid or error
  """

  def format_token_response(response) do
    case response.status_code do
      200 ->
        Pocketex.Response.format(:request_token, response)
      _ ->
        Pocketex.Error.format(:pocket_error, response)
    end
  end

  @doc """
  Checks to see if we've got authorization or not
  returns the authrization data or the error
  """

  def format_response(response) do
    case response.status_code do
      200 ->
        {:ok, Poison.Parser.parse!(response.body)}
      _ ->
        Pocketex.Error.format(:pocket_error, response)
    end
  end

end
