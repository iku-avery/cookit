module Query
  class SearchIngredient
    include Callable

    def initialize(query:)
      @query = query
    end

    def call
      return [] unless @query.present?

      set_pg_trigram_limit(0.2)
      sanitized_query = ActiveRecord::Base.connection.quote_string(@query)

      ProductIngredient
        .where("name % ?", @query)
        .order(Arel.sql("similarity(name, '#{sanitized_query}') DESC"))
    end

    private

    def set_pg_trigram_limit(limit)
      ActiveRecord::Base.connection.execute("SELECT set_limit(#{limit});")
    end
  end
end
