class AutoMLClient
  include HTTParty

  base_uri "https://automl.googleapis.com/v1beta1"

  def initialize
    @token = GoogleToken.generate
    @project_number = ENV["GOOGLE_PROJECT_NUMBER"]
    @address_model_id = ENV["GOOGLE_ADDRESS_MODEL_ID"]
  end

  def predict(content)
    options = {
      headers: {
        Authorization: "Bearer #{@token}",
        'Content-Type': "application/json",
      },
      body: {
        payload: {
          textSnippet: {
            content: content,
            mime_type: "text/plain",
          },
        },
      }.to_json,
    }

    self.class.post(
      "/projects/#{@project_number}/locations/us-central1/models/#{@address_model_id}:predict",
      options
    )
  end
end
