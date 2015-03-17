defmodule Pocketex.Item do
  @moduledoc """
  Wrapper functions for working with items (articles, images, videos) through the Pocket API
  """

  @get_item_method_url  "https://getpocket.com/v3/get"
  @request_headers_json [{"Content-Type", "application/json"}]

  @doc """
  Gets items from the Pocket API, based on the optional parameters
  The optional parameters can be sent in Elixir formatting (underscores) instead
  of Pocket's bumpy case

  Optional Parameters
  state           string            See below for valid values
  favorite        0 or 1            See below for valid values
  tag             string            See below for valid values
  contentType     string            See below for valid values
  sort            string            See below for valid values
  detailType      string            See below for valid values
  search          string            Only return items whose title or url contain the search string
  domain          string            Only return items from a particular domain
  since           timestamp         Only return items modified since the given since unix timestamp
  count           integer           Only return count number of items
  offset          integer           Used only with count; start returning from offset position of results

  state
  unread          = only return unread items (default)
  archive         = only return archived items
  all             = return both unread and archived items

  favorite
  0               = only return un-favorited items
  1               = only return favorited items

  tag
  tag_name        = only return items tagged with tag_name
  _untagged_      = only return untagged items

  contentType
  article         = only return articles
  video           = only return videos or articles with embedded videos
  image           = only return images

  sort
  newest          = return items in order of newest to oldest
  oldest          = return items in order of oldest to newest
  title           = return items in order of title alphabetically
  site            = return items in order of url alphabetically

  detailType
  simple          = only return the titles and urls of each item
  complete        = return all data about each item, including tags, images, authors, videos and more
  """
  def get(consumer_key, access_token, options \\ %{}) do
    payload = Map.merge(%{"consumer_key" => consumer_key, "access_token" => access_token},
                        request_options(options))
    json = to_string(Poison.encode_to_iodata!(payload))

    HTTPoison.start
    HTTPoison.post!(@get_item_method_url, json, @request_headers_json)
    |> Pocketex.Response.format_response
  end

  defp request_options(options) do
    unless Enum.empty?(options) do
      options = Enum.map(options, fn({k, v}) ->
        {Pocketex.Utils.underscore_to_bumpy(Atom.to_string k), v}
      end)
      options = Enum.into(options, %{})
    end

    options
  end

end
