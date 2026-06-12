#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "fileutils"
require_relative "../config/environment"

class SessionDataSchemaGenerator
  OUTPUT_PATH = Rails.root.join("docs/session_data.schema.json")

  TYPE_LOOKUP = {
    "ActiveModel::Type::Boolean" => "boolean",
    "ActiveModel::Type::Integer" => "integer",
    "FullyValidatableInteger" => "integer",
    "ActiveModel::Type::Decimal" => "number",
    "ActiveModel::Type::Float" => "number",
    "Gbp" => "number",
    "ActiveModel::Type::String" => "string",
    "ActiveModel::Type::ImmutableString" => "string",
    "ActiveModel::Type::Value" => "string",
  }.freeze

  def call
    properties = {}
    provenance = Hash.new { |hash, key| hash[key] = [] }

    Flow::Handler::STEPS.each do |step_name, step_config|
      form_class = step_config.fetch(:class)
      add_form_properties(step_name, form_class, properties, provenance)
    end

    add_operational_properties(properties, provenance)
    add_provenance_descriptions(properties, provenance)

    schema = {
      "$schema" => "https://json-schema.org/draft/2020-12/schema",
      "$id" => "https://check-client-qualifies.internal/schemas/session_data.schema.json",
      "title" => "CCQ Session Data",
      "description" => "Schema for the per-assessment session_data hash used by CCQ. Keys are derived from flow form classes and runtime session management keys.",
      "type" => "object",
      "properties" => sort_hash(properties),
      "additionalProperties" => true,
    }

    FileUtils.mkdir_p(OUTPUT_PATH.dirname)
    OUTPUT_PATH.write(JSON.pretty_generate(schema) + "\n")

    OUTPUT_PATH
  end

private

  def add_form_properties(step_name, form_class, properties, provenance)
    attrs = form_attributes(form_class)
    return if attrs.empty?

    item_key = item_session_key(form_class)

    attrs.each do |attr_name|
      session_key = session_key_for(form_class, attr_name)
      property_schema = if item_key && session_key == item_key
                          schema_for_item_collection(form_class::ITEM_MODEL)
                        else
                          schema_for_attribute_type(form_class.attribute_types[attr_name])
                        end

      properties[session_key] = merge_property_schema(properties[session_key], property_schema)
      provenance[session_key] << "#{step_name} (#{form_class.name})"
    end
  end

  def add_operational_properties(properties, provenance)
    properties["feature_flags"] = {
      "type" => %w[object null],
      "additionalProperties" => { "type" => "boolean" },
      "description" => "Feature-flag values snapshotted at journey start.",
    }

    properties["pending"] = {
      "type" => %w[object null],
      "additionalProperties" => true,
      "description" => "Temporary working copy used during check-answers edit loops.",
    }

    properties["early_result"] = {
      "type" => %w[object null],
      "properties" => {
        "result" => { "type" => %w[string null] },
        "gross_income_excess" => { "type" => %w[number null] },
        "type" => { "type" => %w[string null] },
      },
      "additionalProperties" => true,
      "description" => "Early gross-income check outcome cached before full result calculation.",
    }

    properties["api_response"] = {
      "type" => %w[object array null],
      "description" => "Last CFE API response payload cached for result rendering/logging.",
    }

    provenance["feature_flags"] << "session bootstrap"
    provenance["pending"] << "change answers loop"
    provenance["early_result"] << "early result calculation"
    provenance["api_response"] << "journey completion tracking"
  end

  def add_provenance_descriptions(properties, provenance)
    provenance.each do |key, sources|
      deduped_sources = sources.uniq.sort
      next if deduped_sources.empty?

      source_text = "Sources: #{deduped_sources.join(', ')}."
      existing = properties.fetch(key)
      existing["description"] = if existing["description"]
                                  "#{existing['description']} #{source_text}"
                                else
                                  source_text
                                end
    end
  end

  def schema_for_item_collection(item_model)
    item_properties = {}

    item_model::ATTRIBUTES.map(&:to_s).each do |attr_name|
      item_properties[attr_name] = schema_for_attribute_type(item_model.attribute_types[attr_name])
    end

    {
      "type" => %w[array null],
      "items" => {
        "type" => "object",
        "properties" => sort_hash(item_properties),
        "additionalProperties" => true,
      },
    }
  end

  def schema_for_attribute_type(type_object)
    type_name = type_object&.class&.name
    json_type = TYPE_LOOKUP[type_name] || "string"
    { "type" => [json_type, "null"] }
  end

  def merge_property_schema(existing_schema, incoming_schema)
    return incoming_schema unless existing_schema

    existing_types = Array(existing_schema["type"])
    incoming_types = Array(incoming_schema["type"])
    merged = existing_schema.merge(incoming_schema)
    merged["type"] = (existing_types + incoming_types).uniq
    merged
  end

  def form_attributes(form_class)
    return [] unless form_class.const_defined?(:ATTRIBUTES)

    form_class::ATTRIBUTES.map(&:to_s)
  end

  def item_session_key(form_class)
    return unless form_class.const_defined?(:ITEMS_SESSION_KEY)

    form_class::ITEMS_SESSION_KEY
  end

  def session_key_for(form_class, attr_name)
    item_key = item_session_key(form_class)
    return item_key if item_key && attr_name == item_key

    prefix = form_prefix(form_class)
    return attr_name unless prefix

    "#{prefix}#{attr_name}"
  end

  def form_prefix(form_class)
    return unless form_class.const_defined?(:PREFIX)

    form_class::PREFIX
  end

  def sort_hash(hash)
    hash.keys.sort.each_with_object({}) do |key, out|
      out[key] = hash[key]
    end
  end
end

output_path = SessionDataSchemaGenerator.new.call
puts "Wrote #{output_path.relative_path_from(Rails.root)}"
