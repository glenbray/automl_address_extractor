class GoogleToken
  def self.generate
    scope = "https://www.googleapis.com/auth/cloud-platform"
    creds = Google::Auth::ServiceAccountCredentials.make_creds(scope: scope)

    access_token_info = creds.fetch_access_token!
    access_token_info["access_token"]
  end
end
