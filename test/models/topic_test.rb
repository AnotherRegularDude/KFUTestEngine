require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  test 'Two topics with the same title' do
    topic = create(:topic)
    bad_topic = build(:topic)
    bad_topic.title = topic.title.downcase

    assert_not bad_topic.save
    assert_not_nil bad_topic.errors[:title]
  end
end
