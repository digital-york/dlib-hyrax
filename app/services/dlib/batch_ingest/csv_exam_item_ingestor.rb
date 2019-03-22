require 'dog_biscuits'

module Dlib
  module BatchIngest
    # ingest a new record batch from csv metadata. WIP!
    class CSVExamItemIngestor < Hyrax::BatchIngest::BatchItemIngester
      # this method is not yet finished, is still in process of experimentation
      def ingest
        # this is iterating through the json-ised records
        # try to stop the database locking
        ActiveRecord::Base.connection.execute("BEGIN TRANSACTION; END;")
        logfile = File.open('/home/vagrant/csvingestor.log', 'a')
        logfile.puts 'testing the ingestor'

        source_data = JSON.parse(@batch_item.source_data)
        logfile.puts 'the json looks like this' + source_data.to_s
        logfile.close

        # TODO we should use actor methods to do this in a hyrax style
        actor = ::Hyrax::CurationConcern.actor # we should use actor methods
        # TODO parameterise - this is initial placeholder_to_make_it_valid
        user = User.find_by_email 'ps552@york.ac.uk'
        # ability = ::Ability.new(user)

        # Asset.rb is a class defined in ams-develop\app\models\asset.#!/usr/bin/env ruby -wKU
        # I am not sure if it is required by us
        #  asset = ::Asset.new #this is the specific model for the binary

        # https://stackoverflow.com/questions/21666460/in-ruby-on-rails-what-is-an-asset
        # see https://github.com/samvera/hyrax/blob/master/app/controllers/hyrax/downloads_controller.rb
        exam_paper = ExamPaper.new
        exam_paper.depositor = user.email
        logfile = File.open('/home/vagrant/csvingestor.log', 'a')
        logfile.puts 'title from JSON: ' + source_data["title"]
        exam_paper.title.push(source_data["title"])
        exam_paper.former_identifier.push('york:'+ source_data["pid"])
        exam_paper.creator.push(source_data["creator1"]) #this will need elaboration to deal with multiples
        exam_paper.keyword.push('Exam paper') #this will need elaboration to deal with multiples or set default
        exam_paper.rights_statement.push("http://rightsstatements.org/vocab/InC/1.0/") # our one isnt in the list yet, not sure if we can just add
        exam_paper.representative_id = "b2773v68h"  # a fudge, not what we actually want
        exam_paper.source = correct_source(source_data["rights_link"])
        exam_paper.admin_set_id = "8c97kq405"
        exam_paper.save
          # required: title, creator,keyword, rights statement, visibility, check deposit agreement and add a file
        logfile.close
        exam_paper
      end

      def correct_source(initial_url)
        corrected_source = initial_url.sub('local.fedora.server', 'dlib.york.ac.uk')
        corrected_source
      end
    end
  end
end
