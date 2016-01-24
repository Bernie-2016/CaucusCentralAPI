class JsonSerializer
  class << self
    def hash_for(model, attributes)
      res = {}
      attributes.map do |attr|
        res[attr] = model.send attr
      end
      res
    end

    def hash(_model, _options)
      # :nocov:
      fail 'Override in serializer'
      # :nocov:
    end

    def root_hash(model, options = {})
      model_key = name.gsub('Serializer', '').downcase.intern
      node = {}
      node[model_key] = hash(model, options)
      node
    end

    def collection_hash(models, options = {})
      models.map { |model| hash(model, options) }
    end

    def root_collection_hash(models, options = {})
      model_key = name.gsub('Serializer', '').downcase.pluralize.intern
      node = {}
      node[model_key] = collection_hash(models, options)
      node
    end
  end
end
