IF OBJECT_ID('tempdb.dbo.#Temp_Track_Ref') IS NOT NULL
DROP TABLE #Temp_Track_Ref

DECLARE @start	date,
		@end date
SET		@start = '20190901'
SET		@end = '20190930'

CREATE TABLE #Temp_Track_Ref(Report_Date date,
			Territory nvarchar(2),
			DSP varchar(100),
			Identifier varchar(100),
			Streams int,
			Duration int,
			[SalesEquivalents] float);

	INSERT INTO #Temp_Track_Ref
		SELECT		[Report Date] AS Report_Date,
					[Storefront Name] AS Territory,
					'Apple' AS DSP,
					CAST([Apple Identifier] AS varchar(100)) AS Identifier, 
					COUNT(*) AS 'Streams',
					SUM([Stream Duration]) AS Duration,
					ROUND(CAST(COUNT(*) AS float)/1500,5) AS [Sales Equivalents]
			FROM AppleStreams
			WHERE		[Report Date] BETWEEN @start AND @end
			GROUP BY [Report Date], 
						[Storefront Name],
						[Apple Identifier];

	INSERT INTO #Temp_Track_Ref
		SELECT		[date] AS Report_Date, 
					country AS Territory, 
					'Pandora ' + listener_state AS DSP, 
					CAST(track_id AS varchar(100)) AS Identifier,
					COUNT(*) AS 'Streams',
					SUM([elapsed_seconds]) AS Duration,
					ROUND(CAST(COUNT(*) AS float)/1500,5) AS [Sales Equivalents]
			FROM PandoraStreams
			WHERE		[date] BETWEEN @start AND @end
			GROUP BY	[date], 
						country, 
						listener_state, 
						track_id;

	INSERT INTO #Temp_Track_Ref
		SELECT	[date] AS Report_Date,
				[country] AS Territory,
				'Spotify' AS DSP,
				[track_id] AS Identifier, 
				COUNT(*) AS 'Streams',
				SUM([length]) AS 'Duration',
				ROUND(CAST(COUNT(*) AS float)/1500,5) AS [Sales Equivalents]
			FROM SpotifyStreams
			WHERE		[date] BETWEEN @start AND @end
			GROUP BY	[date], 
						[country], 
						[track_id];


SELECT *
FROM #Temp_Track_Ref