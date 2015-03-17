defmodule Pocketex.Error do
  @moduledoc """
  Handles various errors that can be returned by requests
  """

  @doc """
  Wrapper around Pocket error responses
  """
  def format(:pocket_error, response) do
    {
      :ko,
      Dict.merge(Pocketex.Response.format_base(response),
                %{
                  status:     response.headers["Status"],
                  message:    response.headers["X-Error"],
                  error_code: response.headers["X-Error-Code"]
                })
    }
  end
end
