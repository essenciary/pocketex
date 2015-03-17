defmodule PocketexTest do
  use ExUnit.Case

  @consumer_key               Application.get_env(:pocket, :consumer_key)
  @redirect_uri               Application.get_env(:pocket, :redirect_uri)

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

end
