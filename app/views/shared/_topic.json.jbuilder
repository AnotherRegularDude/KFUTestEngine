json.extract! topic, :id, :title, :short_description, :created_at, :updated_at
json.extract! topic, :questions_per_test if policy(topic).show_additional_info?
