require "./test_helper"

class TestBadSpecCharsOutlook < Test::Unit::TestCase
  include MMS2R::TestHelper

  def test_bad_spec_chars_outlook
    mail = mail('bad-spec-chars-from-outlook.mail')
    mms = MMS2R::Media.new(mail)
    body = mms.body
    p body

    mms.purge
  end
end
