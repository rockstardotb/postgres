# First Beam Job
# To run: python beam1.py
#

from __future__ import absolute_import
import argparse
import logging
import warnings
import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions
from apache_beam.options.pipeline_options import SetupOptions
from apache_beam.io.gcp.internal.clients import bigquery

def parse_line(line):
        tokens = line.split(",")
        return tokens[0]

with beam.Pipeline(options=PipelineOptions()) as p:

        lines = p | 'ReadFile' >> beam.io.ReadFromText('gs://rockstardotb/zillow/Zip_MedianRentalPrice_*.csv')
        zipcodes = lines | 'ParseZipcodes' >> (beam.Map(parse_line))

        zipcodes | 'WriteFile' >> beam.io.WriteToText('/home/rockstardotb/tmp/zipcodes', file_name_suffix='.txt')

def convert_price(price):
        if len(price) > 0:
                price = float(price)
        else:
                price = None
        return price

def convert_month(month):
        month_len = len(str(month))
        if month_len == 1:
                month_str = "0" + str(month)
        else:
                month_str = str(month)
        return month_str

def parse_line1(line):

        parsed_records = []

        tokens = line.split(",")
        zipcode_with_quotes = tokens[0]
        zipcode = int(zipcode_with_quotes.strip('"'));

        city_with_quotes=tokens[1]
        city=str(city_with_quotes.strip('"'));
        state_with_quotes=tokens[2]
        state=str(state_with_quotes.strip('"'));
        metro_with_quotes=tokens[3]
        metro=str(metro_with_quotes.strip('"'));
        county_with_quotes=tokens[4]
        county=str(county_with_quotes.strip('"'));

        start_index = 58;
        end_index = start_index + 12;

        year = 2015;
        month = 1;
        day = "01"
        price = 0.0

        for i in range(start_index, end_index):
                price = tokens[i]
                date = str(year) + "-" + convert_month(month) + "-" + day
                parsed_records.append((zipcode, city, state, metro, county))
                month += 1

        return parsed_records


with beam.Pipeline(options=PipelineOptions()) as p:

        lines = p | 'ReadFile1' >> beam.io.ReadFromText('gs://rockstardotb/zillow/Zip_MedianRentalPrice_*.csv')
        list_records = lines | 'CreateListRecords1' >> (beam.Map(parse_line1))
        list_records | 'WriteFile1' >> beam.io.WriteToText('/home/rockstardotb/tmp/list_records', file_name_suffix='.txt')

def parse_line2(line):

        parsed_records = []

        tokens = line.split(",")
        zipcode_with_quotes = tokens[0]
        zipcode = int(zipcode_with_quotes.strip('"'));

        city_with_quotes=tokens[1]
        city=str(city_with_quotes.strip('"'));
        state_with_quotes=tokens[2]
        state=str(state_with_quotes.strip('"'));
        metro_with_quotes=tokens[3]
        metro=str(metro_with_quotes.strip('"'));
        county_with_quotes=tokens[4]
        county=str(county_with_quotes.strip('"'));

        start_year = 2015
        end_year = 2019

        start_month_index = 58; # 2015-01 is on column 58
        end_month_index = start_month_index + 12;

        day = "01"
        price = 0.0

        for year in range(start_year, end_year):

                month = 1;
		try:
	                for month_index in range(start_month_index, end_month_index):

	                        price = tokens[month_index]
	                        price = convert_price(price)

	                        date = str(year) + "-" + convert_month(month) + "-" + day

	                        parsed_records.append((zipcode, city, state, metro, county))

	                        month += 1 # increments up to 12 for years 2015-2017

	                        # only go through the loop once for 2018
	                        if (year == 2018): break
		except:
			break
                start_month_index = end_month_index
                end_month_index = start_month_index + 12

        return parsed_records


with beam.Pipeline(options=PipelineOptions()) as p:

        lines = p | 'ReadFile2' >> beam.io.ReadFromText('gs://rockstardotb/zillow/Zip_MedianRentalPrice_*.csv')

        list_records = lines | 'CreateListRecords2' >> (beam.Map(parse_line2))
        list_records | 'WriteFile2' >> beam.io.WriteToText('/home/rockstardotb/tmp/list_records', file_name_suffix='.txt')

def init_bigquery_table():
	table_schema = bigquery.TableSchema()

	zipcode_field = bigquery.TableFieldSchema()
	zipcode_field.name = 'zipcode'
	zipcode_field.type = 'integer'
	zipcode_field.mode = 'required'
	table_schema.fields.append(zipcode_field)
	
	city_field = bigquery.TableFieldSchema()
	city_field.name = 'city'
	city_field.type = 'string'
	city_field.mode = 'required'
	table_schema.fields.append(city_field)
	
	state_field = bigquery.TableFieldSchema()
	state_field.name = 'state'
	state_field.type = 'string'
	state_field.mode = 'required'
	table_schema.fields.append(state_field)

	metro_field = bigquery.TableFieldSchema()
	metro_field.name = 'metro'
	metro_field.type = 'string'
	metro_field.mode = 'required'
	table_schema.fields.append(metro_field)

	county_field = bigquery.TableFieldSchema()
	county_field.name = 'county'
	county_field.type = 'string'
	county_field.mode = 'required'
	table_schema.fields.append(county_field)
	
	return table_schema;
	
def create_bigquery_record(tuple):

	# tuple format = (zipcode, date, price)
	# For example, (78705, '2015-01-01', 100.0)
	# Note: price is an optional field
		
	zipcode, city, state, metro, county = tuple
	bq_record = {'zipcode': zipcode, 'city': city, 'state': state, 'metro': metro, 'county': county}
	
	return bq_record
	

def parse_line3(line):

	tokens = line.split(",")
	zipcode_with_quotes = tokens[0]
	zipcode = int(zipcode_with_quotes.strip('"'));
	city = tokens[1]
	state = tokens[2]
	metro = tokens[3]
	county = tokens[4]

	parsed_records=((zipcode, city, state, metro, county), 1)
	
	return parsed_records

	
def parse_records(records):

	return records[0]

			
def run(argv=None):	
	
	parser = argparse.ArgumentParser()
	known_args, pipeline_args = parser.parse_known_args(argv)
	pipeline_args.extend([	
      '--runner=DataflowRunner', # use DataflowRunner to run on Dataflow or DirectRunner to run on local VM
      '--project=wide-fx-193021', # change to your project_id
      '--staging_location=gs://rockstardotb/staging', # change to your bucket
      '--temp_location=gs://rockstardotb/tmp', # change to your bucket
      '--job_name=zillow-region' # assign descriptive name to this job, all in lower case letters
	])
	
	pipeline_options = PipelineOptions(pipeline_args)
	pipeline_options.view_as(SetupOptions).save_main_session = True # save_main_session provides global context
	
	with beam.Pipeline(options=pipeline_options) as p:
	

                table_name = "wide-fx-193021:zillow.Region" # format: project_id:dataset.table

		table_schema = init_bigquery_table()

                lines = p | 'ReadFile3' >> beam.io.ReadFromText('gs://rockstardotb/zillow/Zip_MedianRentalPrice_*.csv')
	
		list_records = lines | 'CreateListRecords' >> (beam.Map(parse_line3))

                list_records | 'WriteTmpFile3' >> beam.io.WriteToText('gs://rockstardotb/tmp/list_records', file_name_suffix='.txt')
	
		variable = list_records | beam.GroupByKey()

		tuple_records = variable | 'CreateTupleRecords3' >> (beam.Map(parse_records))

                tuple_records | 'WriteTmpFile4' >> beam.io.WriteToText('gs://rockstardotb/tmp/tuple_records', file_name_suffix='.txt')

		bigquery_records = tuple_records | 'CreateBigQueryRecord3' >> beam.Map(create_bigquery_record)
	
                bigquery_records | 'WriteTmpFile5' >> beam.io.WriteToText('gs://rockstardotb/tmp/bq_records', file_name_suffix='.txt')
	
		bigquery_records | 'WriteBigQuery3' >> beam.io.Write(
		    beam.io.BigQuerySink(
		        table_name,
		        schema = table_schema,
		        create_disposition = beam.io.BigQueryDisposition.CREATE_IF_NEEDED,
		        write_disposition = beam.io.BigQueryDisposition.WRITE_TRUNCATE))

if __name__ == '__main__':
	warnings.filterwarnings("ignore")
	logging.getLogger().setLevel(logging.DEBUG) # change to INFO or ERROR for less verbose logging
	run()
