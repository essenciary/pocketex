defmodule Pocketex.Item do
  @moduledoc """
  Wrapper functions for working with items (articles, images, videos) through the Pocket API
  """

  @get_item_method_url      "https://getpocket.com/v3/get"
  @create_item_method_url   "https://getpocket.com/v3/add"
  @modify_item_method_url   "https://getpocket.com/v3/send"
  @request_headers_json     [{"Content-Type", "application/json"}]

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
  def get(consumer_key, access_token, options) do
    post(consumer_key, access_token, options, @get_item_method_url)
  end
  def get(options) do
    {consumer_key, access_token, options} = extract_options(options)
    get(consumer_key, access_token, options)
  end
  def get(auth, options) do
    get(Dict.merge(auth, options))
  end

  @doc """
  Adds item to Pocket
  """
  def create(consumer_key, access_token, options) do
    post(consumer_key, access_token, options, @create_item_method_url)
  end
  def create(options) do
    {consumer_key, access_token, options} = extract_options(options)
    create(consumer_key, access_token, options)
  end
  def create(auth, options) do
    create(Dict.merge(auth, options))
  end

  @doc """
  Adds item to favorites
  """
  def fav(consumer_key, access_token, item_id) do
    action(consumer_key, access_token, %{item_id: item_id, action: "favorite"})
  end
  def fav(options) do
    {consumer_key, access_token, options} = extract_options(options)
    fav(consumer_key, access_token, options[:item_id])
  end
  def fav(auth, options) do
    fav(Dict.merge(auth, options))
  end

  @doc """
  Remove item from favorites
  """
  def unfav(consumer_key, access_token, item_id) do
    action(consumer_key, access_token, %{item_id: item_id, action: "unfavorite"})
  end
  def unfav(options) do
    {consumer_key, access_token, options} = extract_options(options)
    unfav(consumer_key, access_token, options[:item_id])
  end
  def unfav(auth, options) do
    unfav(Dict.merge(auth, options))
  end

  @doc """
  Archive item
  """
  def archive(consumer_key, access_token, item_id) do
    action(consumer_key, access_token, %{item_id: item_id, action: "archive"})
  end
  def archive(options) do
    {consumer_key, access_token, options} = extract_options(options)
    archive(consumer_key, access_token, options[:item_id])
  end
  def archive(auth, options) do
    archive(Dict.merge(auth, options))
  end

  @doc """
  Unarchive item
  """
  def unarchive(consumer_key, access_token, item_id) do
    action(consumer_key, access_token, %{item_id: item_id, action: "readd"})
  end
  def unarchive(options) do
    {consumer_key, access_token, options} = extract_options(options)
    unarchive(consumer_key, access_token, options[:item_id])
  end
  def unarchive(auth, options) do
    unarchive(Dict.merge(auth, options))
  end

  @doc """
  Delete item
  """
  def delete(consumer_key, access_token, item_id) do
    action(consumer_key, access_token, %{item_id: item_id, action: "delete"})
  end
  def delete(options) do
    {consumer_key, access_token, options} = extract_options(options)
    delete(consumer_key, access_token, options[:item_id])
  end
  def delete(auth, options) do
    delete(Dict.merge(auth, options))
  end

  @doc """
  Adds tags to an item
  """
  def add_tags(consumer_key, access_token, item_id, tags) when is_list(tags) do
    add_tags(consumer_key, access_token, item_id, Enum.join(tags, ", "))
  end
  def add_tags(consumer_key, access_token, item_id, tags) when is_bitstring(tags) do
    tags_action(consumer_key, access_token, item_id, tags, "tags_add")
  end
  def add_tags(options) do
    {consumer_key, access_token, options} = extract_options(options)
    add_tags(consumer_key, access_token, options[:item_id], options[:tags])
  end
  def add_tags(auth, options) do
    add_tags(Dict.merge(auth, options))
  end

  @doc """
  Removes tags from an item
  """
  def remove_tags(consumer_key, access_token, item_id, tags) when is_list(tags) do
    remove_tags(consumer_key, access_token, item_id, Enum.join(tags, ", "))
  end
  def remove_tags(consumer_key, access_token, item_id, tags) when is_bitstring(tags) do
    tags_action(consumer_key, access_token, item_id, tags, "tags_remove")
  end
  def remove_tags(options) do
    {consumer_key, access_token, options} = extract_options(options)
    remove_tags(consumer_key, access_token, options[:item_id], options[:tags])
  end
  def remove_tags(auth, options) do
    remove_tags(Dict.merge(auth, options))
  end

  @doc """
  Replaces tags for an item
  """
  def replace_tags(consumer_key, access_token, item_id, tags) when is_list(tags) do
    replace_tags(consumer_key, access_token, item_id, Enum.join(tags, ", "))
  end
  def replace_tags(consumer_key, access_token, item_id, tags) when is_bitstring(tags) do
    tags_action(consumer_key, access_token, item_id, tags, "tags_replace")
  end
  def replace_tags(options) do
    {consumer_key, access_token, options} = extract_options(options)
    replace_tags(consumer_key, access_token, options[:item_id], options[:tags])
  end
  def replace_tags(auth, options) do
    replace_tags(Dict.merge(auth, options))
  end

  @doc """
  Removes all tags from item
  """
  def clear_tags(consumer_key, access_token, item_id) do
    action(consumer_key, access_token, %{item_id: item_id, action: "tags_clear"})
  end
  def clear_tags(options) do
    {consumer_key, access_token, options} = extract_options(options)
    clear_tags(consumer_key, access_token, options[:item_id])
  end
  def clear_tags(auth, options) do
    clear_tags(Dict.merge(auth, options))
  end

  @doc """
  Ranames tag -- affects all items with this tag
  """
  def rename_tag(consumer_key, access_token, item_id, options) do
    action(consumer_key, access_token, %{item_id: item_id, action: "tag_rename", old_tag: options[:old_tag], new_tag: options[:new_tag]})
  end
  def rename_tag(options) do
    {consumer_key, access_token, options} = extract_options(options)
    rename_tag(consumer_key, access_token, options[:item_id], options)
  end
  def rename_tag(auth, options) do
    rename_tag(Dict.merge(auth, options))
  end

  defp tags_action(consumer_key, access_token, item_id, tags, action) do
    action(consumer_key, access_token, %{item_id: item_id, action: action, tags: tags})
  end

  defp action(consumer_key, access_token, options \\ %{}) do
    {ms, s, _} = :os.timestamp
    payload = [Dict.merge(options, %{time: (ms * 1_000_000 + s)})]
    json = to_string(Poison.encode_to_iodata!(payload))
    uri = @modify_item_method_url <> "?actions=" <> URI.encode_www_form(json) <>
          "&access_token=#{access_token}&consumer_key=#{consumer_key}"

    HTTPoison.start
    HTTPoison.get!(uri)
    |> Pocketex.Response.format_response
  end

  defp post(consumer_key, access_token, options, pocket_endpoint_url) do
    payload = Map.merge(%{"consumer_key" => consumer_key, "access_token" => access_token},
                        request_options(options))
    json = to_string(Poison.encode_to_iodata!(payload))

    HTTPoison.start
    HTTPoison.post!(pocket_endpoint_url, json, @request_headers_json)
    |> Pocketex.Response.format_response
  end

  defp request_options(options) do
    unless Enum.empty?(options) do
      options = Enum.map(options, fn({k, v}) ->
        key = cond do
          is_atom(k)  -> Atom.to_string(k)
          true        -> k
        end
        {Pocketex.Utils.underscore_to_bumpy(key), v}
      end)
      options = Enum.into(options, %{})
    end

    options
  end

  defp extract_options(options) do
    %{consumer_key: consumer_key, access_token: access_token} = options
    options = Dict.drop(options, [:consumer_key, :access_token])

    {consumer_key, access_token, options}
  end

end
