require 'hyrax/batch_ingest'
module Dlib
  module BatchIngest
    # Base class for all item ingester objects.
    class BatchItemIngester < Hyrax::BatchIngest::BatchItemIngester
      # Returns the submitter User.
      # @return [User] the batch submitter
      def submitter
        @submitter ||= User.find_by_email(@batch_item.batch.submitter_email)
      end
    end
  end
end
