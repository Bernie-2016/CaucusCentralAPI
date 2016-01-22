class JsonSerializer
  class << self
    def hash_for(model, attributes)
      res = {}
      attributes.map do |attr|
        res[attr] = model.send attr
      end
      res
    end

    def hash(_model)
      fail 'Override in serializer'
    end

    def root_hash(model)
      model_key = name.gsub('Serializer', '').downcase.intern
      node = {}
      node[model_key] = hash(model)
      node
    end

    def collection_hash(models)
      models.map { |model| hash(model) }
    end

    def root_collection_hash(models)
      model_key = name.gsub('Serializer', '').downcase.pluralize.intern
      node = {}
      node[model_key] = collection_hash(models)
      node
    end
  end
end
