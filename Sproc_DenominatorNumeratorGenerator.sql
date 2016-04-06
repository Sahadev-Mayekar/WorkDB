ALTER PROCEDURE DenominatoNumeratorGererator
	@MeasureID INT,
	@DenomType CHAR(1),
	@AvailableParam VARCHAR(MAX) OUTPUT
AS
BEGIN
-- =============================================
-- Author:		Sahadev Mayekar..
-- Create date: 5-April-2016
-- Description:	This procedure helps in generating parameters that are required to run Stored Procedures to execute measures
-- =============================================
	SET NOCOUNT ON;
	BEGIN
					DECLARE @DeclareSet VARCHAR(MAX),
							@Param VARCHAR(100),
							@Value VARCHAR(100),
							@ParamType CHAR(1) = @DenomType,
							@MinParamNo SMALLINT,
							@MaxParamNo SMALLINT
					SELECT @MinParamNo = Min(SerialNo), @MAXParamNo = Max(SerialNo)
					FROM MeasureConditionValues
					WHERE MeasureID = @MeasureID
					WHILE(@MinParamNo <= @MaxParamNo)
						BEGIN
							
							SELECT @DeclareSet =
								(
								SELECT [Parameters] + ' ' + ParamterDataType + ' = ' +  ISNULL(Value,'NULL') + ',' 
								FROM MeasureConditionValues InnerMCV
								WHERE MeasureID = @MinParamNo AND ParamterType = @DenomType
								Order BY measureid
								For XML Path('')) 
							FROM MeasureConditionValues OuterMCV
							SET @DeclareSet = 'DECLARE ' + SUBSTRING(RTRIM(@DeclareSet),1,LEN(RTRIM(@DeclareSet))-1) 
							PRINT @DeclareSet
							SET @MinParamNo = @MinParamNo + 1
						END
	END
	RETURN
END
