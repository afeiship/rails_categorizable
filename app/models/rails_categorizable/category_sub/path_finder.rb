module RailsCategorizable
  module CategorySub
    module PathFinder
      def path(options = {})
        id_key = options[:id_key] || :id
        name_key = options[:name_key] || :name
        slug_key = options[:slug_key] || :slug
        path_key = options[:path_key] || :path

        current = self
        path_parts = []

        while current
          part = {
            id_key => current.id,
            name_key => current.name,
            slug_key => current.slug,
          }
          Array(options[:include]).each do |field|
            part[field] = current.send(field) if current.respond_to?(field)
          end
          path_parts.unshift(part) # 从根开始
          current = current.parent
        end

        path_parts
      end
    end
  end
end
