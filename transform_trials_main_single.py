import os
import apache_beam as beam
from apache_beam.io import ReadFromText
from apache_beam.io import WriteToText
from datetime import date

# DoFn to perform on each element in the input PCollection.
class beamFunction(beam.DoFn):
  def process(self, element):
    
    #input data names
    record = element
    nct_number = record.get('nct_number') 
    overall_status = record.get('overall_status')
    enrollment = record.get('enrollment')
    start_date = record.get('start_date')
    primary_completion_date = record.get('primary_completion_date')
    
    #check if enrollment exists, if null just change to zero.
    enrollment = str(enrollment)
    enrollment = enrollment.replace('null', '0')

    #extract just the year from date
    start_date = str(start_date)
    year1 = start_date[0:3]
    return year1
 
    #extract just the year from date
    primary_completion_date = str(primary_completion_date)
    year = primary_completion_date[0:3]
    return year
    
    
PROJECT_ID = os.environ['PROJECT_ID']

# Project ID is required when using the BQ source
options = {
    'project': PROJECT_ID
}
opts = beam.pipeline.PipelineOptions(flags=[], **options)

# Create beam pipeline using local runner
with beam.Pipeline('DirectRunner', options=opts) as p:

    query_results = p | 'Read Query' >> beam.io.Read(beam.io.BigQuerySource(query='SELECT * FROM cancer_trials.trials_main LIMIT 1000'))
    
    # write PCollections to log files
    query_results | 'Write log' >> WriteToText('input.txt')

    #apply pardo
    formatted = query_results | 'Tranform Table'>>beam.ParDo(beamFunction())

    # write PCollection to log file
    formatted | 'Write log 2' >> WriteToText('output.txt')
    
    table_name = PROJECT_ID+':cancer_trials.trials_main'
    table_schema = 'nct_number:STRING,official_title:STRING,overall_status:STRING,enrollment:INTEGER,target_duration:STRING,condition:STRING,number_of_groups:INTEGER,enrollment_type:STRING,primary_completion_date:DATE,start_date:DATE'
    
    # write PCollection to new BQ table
    formatted | 'Write BQ table' >> beam.io.Write(beam.io.BigQuerySink(table_name, 
            schema= table_schema,  
            create_disposition=beam.io.BigQueryDisposition.CREATE_IF_NEEDED,
            write_disposition=beam.io.BigQueryDisposition.WRITE_TRUNCATE))
