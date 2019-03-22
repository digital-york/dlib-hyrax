# README

Hyrax application with sqlite3 fixed to 1.3.13, solr version fixed to 6.0.1,
 dog_biscuits installed and configured, dlib_batch-ingest installed
This branch will add some basic configuration for dlib_batch-ingest, however
this customisation is not yet complete, the new classes created are still work
in progress but will show the sort of customisations required. Basically we have
to specify the classes needed to perform batch ingests by editing
config/batch_ingest.yml to tell it what ingest types (eg Exam Papers) are
available, and what classes to use to perform the read and ingest jobs.
Create these in app/services.
For each ingest type, a reader class and an ingestor class must be defined - I
have put these into a subfolder structure dlib/batch_ingest to keep everything
clear and distinct

The classes are not yet complete so the batch ingest function should not be
used at present
