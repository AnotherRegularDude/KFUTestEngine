require 'test_helper'

class MaterialTest < ActiveSupport::TestCase
  test 'convert markdown to html at attr' do
    material = create(:topic_with_materials).materials.first

    assert_match %r{<h3>\w+<\/h3>}, material.processed_html
  end

  test 'description truncated to 255' do
    material = build(:material, :with_rand_topic)
    material.short_description = nil
    material.text_in_markdown = "### Header\n" + Faker::Lorem.paragraphs(10).join

    assert material.save
    assert_equal 255, material.short_description.length
  end

  test 'description added by user' do
    material = build(:material, :with_rand_topic)
    user_short_description = 'my short description'
    material.short_description = user_short_description

    assert material.save
    assert_not_equal user_short_description, material.short_description
    assert_equal user_short_description.humanize, material.short_description
  end
end
