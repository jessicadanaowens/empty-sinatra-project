class S3_file_delete

  def initialize(filename)
    @filename = filename
    @s3_keys =  AWS::S3.new(
      :access_key_id => ENV['ACCESS_KEY_ID'],
      :secret_access_key => ENV['SECRET_ACCESS_KEY']
    )
  end

  def bucket
    @s3_keys.buckets["frame_it_bucket"]
  end

  def delete
    bucket.objects.delete(bucket_name: "frame_it_bucket", key: "#{@filename}")
  end

end