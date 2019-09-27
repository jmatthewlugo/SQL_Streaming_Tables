IF OBJECT_ID('tempdb.dbo.#Tracks') IS NOT NULL
DROP TABLE #Tracks

DECLARE @start	date,
@end date
SET @start = '20190901';
SET	@end = '20190902';

	CREATE TABLE #Tracks(
		Identifier varchar(200),
		Track_Title varchar(MAX),
		Artist varchar(MAX),
		ISRC varchar(50),
		UPC varchar(20),
		Label varchar(100),
		DSP varchar(50),
		ReleaseDate date
		)

	INSERT INTO #Tracks
		SELECT DISTINCT track_id AS Identifier, 
				track_title AS Track_Title, 
				artist_name AS Artist, 
				isrc AS ISRC, 
				CASE 
				WHEN LEN(P.upc) >= 12 THEN CAST(P.upc AS varchar(20))
				ELSE REPLICATE('0', 12-LEN(P.upc)) + CAST(P.upc AS varchar(20))
				END AS UPC, 
				L.LabelDesc AS Label,
				'Pandora' AS DSP,
				C.ReleaseDate AS ReleaseDate
			FROM PandoraTracks P
				LEFT JOIN [MM2].[dbo].[tblCatalogue] C
				ON (CASE 
					WHEN LEN(P.upc) >= 12 THEN CAST(P.upc AS varchar(20))
					ELSE REPLICATE('0', 12-LEN(P.upc)) + CAST(P.upc AS varchar(20))
				END) = C.BarCode
			LEFT JOIN [MM2].[dbo].[Label] L
			ON C.CatLabelID = L.LabelID
			WHERE [date] BETWEEN @start AND @end

	INSERT INTO #Tracks
		SELECT DISTINCT [Apple Identifier], 
			[Title], 
			[Artist], 
			[ISRC], 
			'' AS UPC,
			[Label/Studio/Network] AS Label, 
			'Apple' AS DSP,
			'2000-01-01' AS ReleaseDate
			FROM AppleTracks
			WHERE [Report Date] BETWEEN @start AND @end

	INSERT INTO #Tracks
		SELECT DISTINCT track_id AS Identifier, 
			T.track_name AS Track_Title, 
			T.track_artists AS Artist, 
			T.isrc AS ISRC, 
				CASE 
				WHEN LEN(T.album_code) >= 12 THEN CAST(T.album_code AS varchar(20))
				ELSE REPLICATE('0', 12-LEN(T.album_code)) + CAST(T.album_code AS varchar(20))
				END AS UPC,
			L.LabelDesc,
			'Spotify' AS DSP,
			tc.ReleaseDate AS ReleaseDate
			FROM SpotifyTracks T
			LEFT JOIN [MM2].[dbo].[tblCatalogue] tc
				ON
				CASE 
				WHEN LEN(T.album_code) >= 12 THEN CAST(T.album_code AS varchar(20))
				ELSE REPLICATE('0', 12-LEN(T.album_code)) + CAST(T.album_code AS varchar(20))
				END = tc.BarCode
			LEFT JOIN [MM2].[dbo].[Label] L
			ON tc.CatLabelID = L.LabelID
			WHERE [date] BETWEEN @start AND @end

	UPDATE #Tracks
		SET
				Label = L.LabelDesc
			,UPC = tc.BarCode
		FROM
			#Tracks ttt
			LEFT JOIN [MM2].[dbo].[tblCatalogue] tc ON REPLICATE('0', 13-LEN(UPC)) + CAST(UPC AS varchar(20)) = tc.BarCode
			LEFT JOIN [MM2].[dbo].[Label] L ON tc.CatLabelID = L.LabelID
		WHERE
			ttt.Label IS NULL

SELECT *
FROM #Tracks