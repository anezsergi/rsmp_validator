# Setup templaty and serialize all relevant objects
def init
  super

  # serialize objects
  Registry.all(:context,:specification).each do |object|
    p object
    options.serializer.extension = 'md'
    serialize object
  rescue => e
    path = options.serializer.serialized_path object
    log.error "Exception occurred while generating '#{path}': #{e}"
    log.backtrace e
  end
end

# Generate document from object
def serialize object
  options.object = object
  Templates::Engine.with_serializer(object, options.serializer) do
    template_name = object.type.to_s
    T(template_name).run(options)
  end
end
