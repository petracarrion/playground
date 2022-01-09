import pandas as pd
import fastavro


def avro_df(filepath):
    # Open file stream
    with open(filepath, 'rb') as fp:
        # Configure Avro reader
        reader = fastavro.reader(fp)
        # Load records in memory
        records = [r for r in reader]
        # Populate pandas.DataFrame with records
        return pd.DataFrame.from_records(records)


df = avro_df('data/data.avro')

print(df)
