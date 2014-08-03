require "active_record"

class Photo < ActiveRecord::Base

  def upload(session_id, filename, s3_url)
    Photo.create(
      :user_id=>session_id,
      :filename=>filename,
      :tempfile=>s3_url
    )
  end


end