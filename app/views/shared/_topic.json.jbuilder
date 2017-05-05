json.extract! topic, :title, :short_description
json.extract! topic, :questions_per_test if policy(topic).show_additional_info?
