Rails.application.config.cache_store = :memory_store, { size: 2.megabytes }

# Reload because the cache was previously created in basic inintialization
Rails.cache = ActiveSupport::Cache.lookup_store(Rails.application.config.cache_store)

