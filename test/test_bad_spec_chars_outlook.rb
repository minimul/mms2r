require "./test_helper"

class TestBadSpecCharsOutlook < Test::Unit::TestCase
  include MMS2R::TestHelper

  def test_bad_spec_chars_outlook
    mail = mail('bad-spec-chars-from-outlook.mail')
    mms = MMS2R::Media.new(mail)
    body = mms.body
    p body
    #assert
    #assert_match(/AA¢A,\u0080A,\u0099showpicture\.jpeg$/, mms.media['image/jpeg'].first)

    mms.purge
  end
end
