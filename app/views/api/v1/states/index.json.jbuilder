json.states do
  json.array! states, partial: 'state', as: :state
end
