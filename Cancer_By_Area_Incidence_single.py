import apache_beam as beam
from apache_beam.io import ReadFromText
from apache_beam.io import WriteToText

# DoFn to perform on each element in the input PCollection.
class AvgCancerStat(beam.DoFn):
  def process(self, element):
    crude_rate = Cancer_By_Area_Incidence.get('crude_rate')
    population = Cancer_By_Area_Incidence.get('population')
    area = Cancer_By_Area_Incidence.get('area'.'alabama')
    age_adjusted_rate= Cancer_By_Area_Incidence.get('age_adjusted_rate')

  .apply(GroupByKey.<area, age_adjusted_rate>create())
  .apply(GroupByKey.<area, crude_rate>create())
  
  float total_crude = 0
  for (FLOAT crude : crude_rate) {
            total_crude += crude;
        }
  
  float total_age = 0
  for (FLOAT age : age_adjusted_rate) {
            total_age += age;
        }
  return [total_age/age_adjusted_rate.length(), total_crude/crude_rate.length()]
    
    
PROJECT_ID = os.environ['dogwood-outcome-231223']

# Project ID is required when using the BQ source
options = {
    'project': PROJECT_ID
}
opts = beam.pipeline.PipelineOptions(flags=[], **options)

# Create beam pipeline using local runner
with beam.Pipeline('DirectRunner', options=opts) as p:

    query = p | 'Read Query' >> beam.io.Read(beam.io.BigQuerySource(query='SELECT crude_rate, population,age_adjusted_rate, area FROM cancer_stats.Cancer_By_Area_Incidence LIMIT 1000'))
    
    formatted_dob_pcoll = query_results | 'Format DOB' >> beam.ParDo(AvgCancerStat())

    # write PCollections to log files
    p | 'Write log' >> WriteToText('input.txt')

    # write PCollection to log file
    formatted_dob_pcoll | 'Write log 2' >> WriteToText('output.txt')
    
    # write PCollection to new BQ table
    norm_takes_pcoll | 'Write BQ table' >> beam.io.Write(beam.io.BigQuerySink(AvgCancerArea, 
            schema= 'area:STRING, avg_crude:FLOAT,population:INT,avg_age_adjusted_Rate:FLOAT',  
            create_disposition=beam.io.BigQueryDisposition.CREATE_IF_NEEDED,
            write_disposition=beam.io.BigQueryDisposition.WRITE_TRUNCATE))
