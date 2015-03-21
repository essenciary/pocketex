![pocketex_logo](http://essenciary.com/public/pocketex2_128.png)
#Pocketex
Pocketex is an Elixir client for the Pocket read later service ([getpocket.com]())


##Getting started

* Get a consumer key for your app from [http://getpocket.com/developer/apps/new]()
* Setup a web page in your app which will serve as the redirect URL where Pocket
will POST the auth data at the end of the authorization process.
Look here for more details: [http://getpocket.com/developer/docs/authentication]()

1. Get a request token:

`{:ok, response} = Pocketex.Auth.get_request_token(@consumer_key, @redirect_uri)`

2. and redirect the user to the Pocket oAuth2 page, for authentication and
authorization, passing in your received request token and the callback URL.

```request_token = response[:request_token]
redirect(external: Pocketex.Auth.autorization_uri(response[:request_token], (WebUi.Router.Helpers.pocket_path(conn, :callback) |> WebUi.Endpoint.url)))```

3. Upon successful authentication and authorization, you will receive an
access token which will be used for further requests.

`{:ok, response} = Pocketex.Auth.authorize(@consumer_key, request_token)
access_token = response["access_token"]`

4. You're good to go now
`response = Pocketex.Item.get(@consumer_key, access_token,
                            %{count: 10, detail_type: "complete", sort: "newest",
                            state: "unread", content_type: "all"})`

For additional information, check out the example app (https://github.com/essenciary/pocketex_demo_app)
or the docs (http://essenciary.github.io/pocketex/doc/)
