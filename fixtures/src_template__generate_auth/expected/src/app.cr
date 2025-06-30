require "./shards"

# Load the asset manifest
# In development, vite-plugin-dev-manifest creates public/manifest.dev.json
# In production, Vite creates public/.vite/manifest.json
# The manifest path is determined by which file exists at compile time
{% if File.exists?("public/manifest.dev.json") %}
  Lucky::AssetHelpers.load_manifest "public/manifest.dev.json", use_vite: true
{% elsif File.exists?("public/.vite/manifest.json") %}
  Lucky::AssetHelpers.load_manifest "public/.vite/manifest.json", use_vite: true
{% else %}
  # For initial compilation, we'll assume development mode
  # The dev server will create the manifest before the app is recompiled
  Lucky::AssetHelpers.load_manifest "public/manifest.dev.json", use_vite: true
{% end %}

require "../config/server"
require "./app_database"
require "../config/**"
require "./models/base_model"
require "./models/mixins/**"
require "./models/**"
require "./queries/mixins/**"
require "./queries/**"
require "./operations/mixins/**"
require "./operations/**"
require "./serializers/base_serializer"
require "./serializers/**"
require "./emails/base_email"
require "./emails/**"
require "./actions/mixins/**"
require "./actions/**"
require "./components/base_component"
require "./components/**"
require "./pages/**"
require "../db/migrations/**"
require "./app_server"