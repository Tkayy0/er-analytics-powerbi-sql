// patients_dataset.m
// Power Query (M) that loads and prepares the visit data for the dashboard.
// The file path is a placeholder: point it at your own copy of the CSV.
//
// Steps:
//   1. Read the CSV and promote the first row to headers.
//   2. Keep the last two characters of the date text in a "Moment" column
//      (the AM/PM marker used by the AM and PM filter).
//   3. Convert the date column to a date, then to text and back so it holds the date only.
//   4. Merge the first initial and last name into a "Full Name" column.
//   5. Set the data types on the wait time, satisfaction score and age columns.

let
    Source = Csv.Document(
        File.Contents("C:\path\to\Hospital ER 2.csv"),
        [Delimiter = ",", Columns = 11, Encoding = 65001, QuoteStyle = QuoteStyle.None]
    ),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    #"Inserted Last Characters" = Table.AddColumn(#"Promoted Headers", "Last Characters", each Text.End([date], 2), type text),
    #"Renamed Columns" = Table.RenameColumns(#"Inserted Last Characters", {{"Last Characters", "Moment"}}),
    #"Changed Type" = Table.TransformColumnTypes(#"Renamed Columns", {{"date", type datetime}}),
    #"Extracted First Characters" = Table.TransformColumns(#"Changed Type", {{"date", each Text.Start(Text.From(_, "en-GB"), 10), type text}}),
    #"Merged Columns" = Table.CombineColumns(#"Extracted First Characters", {"patient_first_inital", "patient_last_name"}, Combiner.CombineTextByDelimiter(" ", QuoteStyle.None), "Full Name"),
    #"Changed Type1" = Table.TransformColumnTypes(#"Merged Columns", {{"patient_waittime", Int64.Type}, {"patient_sat_score", Int64.Type}, {"patient_age", Int64.Type}, {"date", type date}})
in
    #"Changed Type1"
