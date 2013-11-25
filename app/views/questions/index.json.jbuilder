json.array!(@questions) do |question|
  json.extract! question, :description, :dificulty, :image, :answer
  json.url question_url(question, format: :json)
end
