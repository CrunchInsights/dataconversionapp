
#'AKIAJCN6M7H4D7O72GBA',
#'3+4IJRYnoSBaqU3Tfvx3DceGtM1HFGfiH87IF9sK'
#"crunchinsights-assets"
AWS.config(
            :access_key_id =>'AKIAJCN6M7H4D7O72GBA',#ENV['AWS_ACCESS_KEY_ID'],
            :secret_access_key => '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'#ENV['AWS_SECRET_ACCESS_KEY']             
          )
S3_BUCKET = AWS::S3.new.buckets["crunchinsights-assets"]#ENV['S3_BUCKET_NAME']