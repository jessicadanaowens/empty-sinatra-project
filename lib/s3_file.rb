class S3_file

  def initialize(picture_data)
    @picture_data = picture_data
    @s3_keys =  AWS::S3.new(
      :access_key_id => ENV['ACCESS_KEY_ID'],
      :secret_access_key => ENV['SECRET_ACCESS_KEY']
    )
  end

  def picture_name
    @picture_data[:filename].gsub(' ', '_')
  end

  def bucket
    @s3_keys.buckets["frame_it_bucket"]
  end

  def filename
    bucket.objects[picture_name]
  end

  def path
    filename.public_url
  end

  def tempfile_info
    unless @picture_data == nil
      @picture_data[:tempfile]
    end
  end

  def write
    unless @picture_data == nil
      filename.write(tempfile_info.read)
    end
  end
end