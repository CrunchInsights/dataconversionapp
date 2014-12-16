json.array!(@datauploaders) do |datauploader|
  json.extract! datauploader, :id
  json.url datauploader_url(datauploader, format: :json)
end
