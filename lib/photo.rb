require "active_record"

class Photo < ActiveRecord::Base

  def self.upload(session_id, filename, tempfile)
    Photo.create(
      :user_id=>User.user_id(session_id),
      :filename=>filename,
      :tempfile=>tempfile
    )
  end


end