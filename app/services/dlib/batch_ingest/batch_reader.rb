module Dlib
  module BatchIngest
    # inherits superclass methods while overiding unwanted method
    class BatchReader < Hyrax::BatchIngest::BatchReader
      def delete_manifest
        # override to avoid raising 'abstact class' error
        true
      end
    end
  end
end
