require 'csv'

# class to read legacy metadata from a csv exam paper records file. WIP!
module Dlib
  module BatchIngest
    # parse csv record metadata
    class CsvExamsReader < Dlib::BatchIngest::BatchReader
      # returns an array  of hashes (@batch_items)
      # each hash represents a row of key:value pairs
      # each row_hash can then be parsed to Hyrax::BatchIngest::BatchItem.new
      # and each batchItem put into the @batch_items array
      # WIP - this is a placeholder demonstrating a basic method
      def perform_read
        csv_records = File.read(@source_location)
        @batch_items = [] # array of hashes. 1hash = 1row. (key:value pairs)
        headers = CSV.foreach(@source_location).first
        parsed_csv = CSV.parse(csv_records, headers: true)
        formatted_row_data_array = source_data_to_model_hash(parsed_csv, headers)
        formatted_row_data_array.each do |row|
          @batch_items << Hyrax::BatchIngest::BatchItem.new(id_within_batch: row,
                                                            source_data: row.to_json, status: :initialized)
        end
      end

      def source_data_to_model_hash(parsed_csv, headers)
        all_rows = []
        parsed_csv.each do |csvrow|
          row_data = {} # hash, i hash = 1 row
          headers.each do |h|
            header_name = h.to_s
            value_in_row = csvrow[header_name]
            row_data[header_name.to_sym] = value_in_row if value_in_row
          end
          # not all our data has keywords but we need placeholder to make it
          # valid. we may need to modify the model as this is a required field
          # in basic hyrax as well as dog_biscuits.
          keyword_present = csvrow[:subject1]
          row_data['subject1'.to_sym] = 'Exam Paper' unless keyword_present
          row_data['model'.to_sym] = 'ExamPaper'
          all_rows << row_data
        end
        all_rows
      end
    end
  end
end
