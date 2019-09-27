INSERT INTO [September Spotify Aggregation]
    SELECT [date], country,[track_id], source_uri, COUNT(*) AS "Stream Count"
    FROM   SpotifyStreams
    WHERE [date] BETWEEN '20190901' AND '20190930'
    GROUP BY [date],[country], track_id, source_uri

INSERT INTO [September Apple Aggregation]
    SELECT [Report Date], [Storefront Name], [Source of Stream],[Apple Identifier], COUNT(*) AS "Stream Count"
    FROM   AppleStreams
    WHERE [Report Date] BETWEEN '20190801' AND '20190901'
    GROUP BY [Report Date], [Source of Stream], [Storefront Name], [Apple Identifier]

INSERT INTO [September Pandora Aggregation]
    SELECT date, country, listener_state, zipcode, track_id, COUNT(*)
    FROM Temp_Pandora
    WHERE [date] BETWEEN '2019-08-01' AND '2019-08-31'