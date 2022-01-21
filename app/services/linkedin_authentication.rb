module LinkedinAuthentication
  require 'uri'
  require 'net/http'

  def send_request(uri, headers, request_type, request_body = '')
    uri = URI.parse(uri)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    response = request_type == "post" ? https.post(uri, request_body.to_json, headers) : https.get(uri, headers)
    response.body
  end

  def linked_in_authorizaion_url
    client = LinkedIn::Client.new(ENV["LINKEDIN_CLIENT_ID"], ENV["LINKEDIN_CLIENT_SECRET"])
    client.authorize_url(:redirect_uri => ENV["LINKEDIN_REDIRECT_URL"], :state => SecureRandom.uuid, :scope => "w_member_social,w_organization_social,r_basicprofile")
  end

  def get_access_token(encrypted_code)
    headers = { 'Content-Type': 'application/x-www-form-urlencoded' }
    url = "https://www.linkedin.com/oauth/v2/accessToken?grant_type=authorization_code&redirect_uri=#{ENV["LINKEDIN_REDIRECT_URL"]}&code=#{encrypted_code}&client_id=#{ENV["LINKEDIN_CLIENT_ID"]}&client_secret=#{ENV["LINKEDIN_CLIENT_SECRET"]}"
    send_request(url, headers, "post")
  end

  def get_profile_information(access_token)
    headers = { 'Content-Type': 'application/json', "Authorization": "Bearer #{access_token}" }
    url = "https://api.linkedin.com/v2/me"
    send_request(url, headers, "get")
  end

  def share_post(post_id, user_id, commentry)
    post = current_company.posts.find(post_id)
    user = current_company.users.find(user_id)
    headers = { 'Content-Type': 'application/json', "Authorization": "Bearer #{Encryptor.decrypt(user.linked_in_code)}"  }
    url = "https://api.linkedin.com/v2/shares"
    request_body = {
      "content": {
        "contentEntities": [
          {
            "entityLocation": ENV["APP_URL"],
            "thumbnails": [
              {
                "imageSpecificContent": {
                  "size":141287,
                  "width":1600,
                  "height":900
                },
                "resolvedUrl": post.image.url
              }
            ]
          }
        ],
        "title": post.title
      },
      "distribution": {
        "linkedInDistributionTarget": {}
      },
      "owner": "urn:li:person:#{Encryptor.decrypt(user.linked_in_id)}",
      "subject": post.title,
      "text": {
        "text": commentry
      }
    }
    send_request(url, headers, "post",  request_body)
  end
end