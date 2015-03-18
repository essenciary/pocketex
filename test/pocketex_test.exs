defmodule PocketexTest do
  use ExUnit.Case, async: false

  @consumer_key               Application.get_env(:pocket, :consumer_key)
  @redirect_uri               Application.get_env(:pocket, :redirect_uri)

  @website_test_url           "https://www.google.com/search?q=this+is+a+Pocketex+test"
  @test_delete_tag            "_test_item_google_delete_"

  # get this from the demo app after authenticating
  # http://localhost:4000/pocket/user_info
  @access_token               "97d7d713-b89b-8a3c-79df-6c29e3" #DELETE_ME

  setup_all do
    assert {:ok, _} = Pocketex.Item.create(@consumer_key, @access_token,
                      %{url: @website_test_url, title: "Just Google", tags: "search engine, google, #{@test_delete_tag}"})

    on_exit fn ->
      assert {:ok, _} = Pocketex.Item.delete(@consumer_key, @access_token, get_pocket_item_id)
    end
  end

  test "obtain request token" do
    {:ok, response} = Pocketex.Auth.get_request_token(@consumer_key, @redirect_uri)
    assert response.status_code == 200
  end

  test "requesting token with wrong consumer key should fail" do
    {:ko, response} = Pocketex.Auth.get_request_token("abcd", @redirect_uri)
    assert  response.status_code == 403 &&
            response.message == "Invalid consumer key." &&
            response.status == "403 Forbidden"
  end

  test "convert abcd to abcd" do
    assert Pocketex.Utils.underscore_to_bumpy("abcd") == "abcd"
  end

  test "convert ab_cd to abCd" do
    assert Pocketex.Utils.underscore_to_bumpy("ab_cd") == "abCd"
  end

  test "convert ab_cd_ef to abCdEf" do
    assert Pocketex.Utils.underscore_to_bumpy("ab_cd_ef") == "abCdEf"
  end

  test "get a random item from Pocket" do
    assert {:ok, _} = Pocketex.Item.get(@consumer_key, @access_token, %{count: 1})
  end

  test "get Pocket item by tag, fav it and unfav it" do
    assert {:ok, _} = Pocketex.Item.fav(@consumer_key, @access_token, get_pocket_item_id)
    assert {:ok, _} = Pocketex.Item.unfav(@consumer_key, @access_token, get_pocket_item_id(1))
  end

  test "get Pocket item by tag, archive it and unarchive it" do
    assert {:ok, _} = Pocketex.Item.archive(@consumer_key, @access_token, get_pocket_item_id)
    assert {:ok, _} = Pocketex.Item.unarchive(@consumer_key, @access_token, get_pocket_item_id(0, "archive"))
  end

  test "Pocket item should be unfav and unread" do
    get_pocket_item
  end

  def get_pocket_item_id(favorite \\ 0, state \\ "unread") do
    get_pocket_item(favorite, state) |> Map.keys |> List.first |> String.to_integer
  end

  def get_pocket_item(favorite \\ 0, state \\ "unread") do
    assert {:ok, test_item} = Pocketex.Item.get(@consumer_key, @access_token, %{tag: @test_delete_tag, state: state, favorite: favorite})

    test_item["list"]
  end

end
