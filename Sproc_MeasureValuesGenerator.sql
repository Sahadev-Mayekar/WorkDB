USE [Navigate]
GO

/****** Object:  StoredProcedure [dbo].[MeasureValuesGenerator]    Script Date: 4/5/2016 6:07:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[MeasureValuesGenerator]
	
	@MeasureName VARCHAR(MAX) = 'ALL',
	@AvailableParam VARCHAR(MAX) OUTPUT
AS
BEGIN
-- =============================================
-- Author:		Sahadev Mayekar..
-- Create date: 5-April-2016
-- Description:	This procedure helps in generating parameters that are required to run Stored Procedures to execute measures
-- =============================================
	SET NOCOUNT ON;
	DECLARE @ParameterSet VARCHAR(MAX),
			@MinMeasureCounter SMALLINT,
			@MaxMeasureCounter SMALLINT

	-- to set starting and ending limit on loop
	SELECT @MinMeasureCounter = MIN(MeasureID), @MaxMeasureCounter = MAX(MeasureID)
	FROM MeasureMaster WITH(NOLOCK)
	WHERE IsActive = 'Y'
	
	WHILE (@MinMeasureCounter <= @MaxMeasureCounter)
		BEGIN
			DECLARE @MeasureID VARCHAR(100)
					
			
			SELECT @MeasureID = MeasureID 
			FROM MeasureMaster WITH(NOLOCK)
			WHERE MeasureID = @MinMeasureCounter
			PRINT @MeasureID
			
				EXECUTE DenominatoNumeratorGererator @MinMeasureCounter, 'A', @AvailableParam = @AvailableParam OUTPUT

			SET @MinMeasureCounter = @MinMeasureCounter + 1

		END
END

GO


