DECLARE 
         @CorporateLogicFactorId INT = 1
        ,@TechnicalModelYearFactorId INT = 2
        ,@StructureWeekFactorId INT = 3
        ,@AssemblyPlantFactorId INT = 4
        ,@CountryFactorId INT = 5
        ,@VehicleClusterFactorId INT = 6
        ,@VehicleTypeFactorId INT = 7
        ,@EngineFactorId INT = 8
        ,@TransmissionFactorId INT = 9
        ,@FuelTypeFactorId INT = 10
        ,@PropulsionSystemFactorId INT = 11
        ,@SteeringFactorId INT = 12
        ,@WarrantyOrgFactorID INT = 13
        ,@WarrantyPartFactorID INT = 14
        ,@IncludeZeroMisPartFactorId INT = 15
        ,@DtcOrgFactorId INT = 16
        ,@DtcFactorId INT = 17
        ,@DtcStatusFlag INT = 18
        ,@WarrantyCscFactorID INT = 18
        ,@IncludeZeroMisCscFactorId INT = 19

        ,@GroupVehicleOptions INT = 1
        ,@GroupEventWarrantyPart INT = 2
        ,@GroupEventDtc INT = 3
        ,@GroupEventWarrantyCsc INT = 4


        ,@GroupId INT = 3


DECLARE @CombinationTVP MyQ_CombinationTableType

INSERT INTO @CombinationTVP (FactorId,OptionId)
VALUES (2,2019)





IF @GroupId = @GroupEventDtc
    BEGIN
        DROP TABLE IF EXISTS #Available_Dtc_Data
        CREATE TABLE #Available_Dtc_Data
        (
            Ecu_Id INT,
            Dtc_Id INT
        )

        DECLARE @AvailableDtcOptions NVARCHAR(1600) = 
                                                    N'SELECT DISTINCT Ecu_Id,Dtc_Id '
                                                    + 'FROM Dim_Dtc_Event_Combinations dec '
                                                    + 'INNER JOIN Dim_MyQ_PNO pno ON dec.FK_MyQ_PNO_ID = pno.ID '
                                                    + 'WHERE 1=1 '

        IF EXISTS (SELECT 1 FROM @CombinationTVP WHERE FactorId = @TechnicalModelYearFactorId)
            SET @AvailableDtcOptions += 'AND Technical_Model_Year IN (SELECT OptionId FROM @CombinationTVP WHERE FactorId = ' + CAST(@TechnicalModelYearFactorId AS char(1)) + ')'
        IF EXISTS (SELECT 1 FROM @CombinationTVP WHERE FactorId = @StructureWeekFactorId)
            SET @AvailableDtcOptions += 'AND Structure_Week IN (SELECT OptionId FROM @CombinationTVP WHERE FactorId = ' + CAST(@StructureWeekFactorId AS char(1)) + ')'
        IF EXISTS (SELECT 1 FROM @CombinationTVP WHERE FactorId = @AssemblyPlantFactorId)
            SET @AvailableDtcOptions += 'AND FK_Assembly_Plant_ID IN (SELECT OptionId FROM @CombinationTVP WHERE FactorId = ' + CAST(@AssemblyPlantFactorId AS char(1)) + ')'
        IF EXISTS (SELECT 1 FROM @CombinationTVP WHERE FactorId = @CountryFactorId)
            SET @AvailableDtcOptions += 'AND FK_Retail_Delivery_Country_Id IN (SELECT OptionId FROM @CombinationTVP WHERE FactorId = ' + CAST(@CountryFactorId AS char(1)) + ')'
        IF EXISTS (SELECT 1 FROM @CombinationTVP WHERE FactorId = @VehicleClusterFactorId)
            SET @AvailableDtcOptions += 'AND FK_Dim_Factor_Cluster_ID IN (SELECT OptionId FROM @CombinationTVP WHERE FactorId = ' + CAST(@VehicleClusterFactorId AS char(1)) +')'
        IF EXISTS (SELECT 1 FROM @CombinationTVP WHERE FactorId = @VehicleTypeFactorId)
            SET @AvailableDtcOptions += 'AND FK_Dim_Factor_Vehicle_Type_ID IN (SELECT OptionId FROM @CombinationTVP WHERE FactorId = ' + CAST(@VehicleTypeFactorId AS char(1)) +')'
        IF EXISTS (SELECT 1 FROM @CombinationTVP WHERE FactorId = @EngineFactorId)
            SET @AvailableDtcOptions += 'AND FK_Dim_Factor_Engine_ID IN (SELECT OptionId FROM @CombinationTVP WHERE FactorId = ' + CAST(@EngineFactorId AS char(1)) + ')'
        IF EXISTS (SELECT 1 FROM @CombinationTVP WHERE FactorId = @TransmissionFactorId)
            SET @AvailableDtcOptions += 'AND FK_Dim_Factor_Transmission_ID IN (SELECT OptionId FROM @CombinationTVP WHERE FactorId = ' + CAST(@TransmissionFactorId AS char(1)) + ')'
        IF EXISTS (SELECT 1 FROM @CombinationTVP WHERE FactorId = @FuelTypeFactorId)
            SET @AvailableDtcOptions += 'AND FK_Dim_Factor_Fuel_Type_ID IN (SELECT OptionId FROM @CombinationTVP WHERE FactorId = ' + CAST(@FuelTypeFactorId AS char(2)) + ')'
        IF EXISTS (SELECT 1 FROM @CombinationTVP WHERE FactorId = @PropulsionSystemFactorId)
            SET @AvailableDtcOptions += 'AND FK_Dim_Factor_Propulsion_System_ID IN (SELECT OptionId FROM @CombinationTVP WHERE FactorId = ' + CAST(@PropulsionSystemFactorId AS char(2)) + ')'
        IF EXISTS (SELECT 1 FROM @CombinationTVP WHERE FactorId = @SteeringFactorId)
            SET @AvailableDtcOptions += 'AND FK_Dim_Factor_Steering_ID IN (SELECT OptionId FROM @CombinationTVP WHERE FactorId = ' + CAST(@SteeringFactorId AS char(2)) + ')'
        IF EXISTS (SELECT 1 FROM @CombinationTVP WHERE FactorId = @WarrantyOrgFactorID)
            SET @AvailableDtcOptions += 'AND FK_Dim_Factor_Function_Group_ID IN (SELECT OptionId FROM @CombinationTVP WHERE FactorId = ' + CAST(@WarrantyOrgFactorID AS char(4)) + ')'

        INSERT INTO #Available_Dtc_Data
        EXEC SP_EXECUTESQL @AvailableDtcOptions,N'@CombinationTVP MyQ_CombinationTableType READONLY', @CombinationTVP 

        ------------------------------------------------------
        ------ Get Avaiable Values ---------------------------
        ------------------------------------------------------

        SELECT
            [Level]
            ,B.Id
            ,B.[Name]
            ,@DtcOrgFactorId AS FactorId
            ,Null AS AdditionalData
            ,CAST(0 AS BIT) AS IsDefault 
            ,ParentId
        FROM
        (
            SELECT 
                ecu.ID ecu_id
                ,ecu.ECU_Short_Name 
                ,ecu.FK_Dim_Factor_Department_ID
                ,od.ID od_id
                ,od.Department_Name
            FROM 
                (SELECT DISTINCT Ecu_Id FROM #Available_Dtc_Data) dd
                INNER JOIN Dim_Factor_Ecu ecu ON dd.Ecu_Id = ecu.ID
                INNER JOIN Dim_Factor_Department od ON ecu.FK_Dim_Factor_Department_ID = od.ID
        ) DtcOrg
        CROSS APPLY 
        ( VALUES
             (2,Ecu_Id, ECU_Short_Name, FK_Dim_Factor_Department_ID)
            ,(1,od_id, Department_Name, NULL)
        ) B ([Level],Id, [Name],ParentId)
        GROUP BY
            B.Id
            ,B.[Name]
            ,ParentId
            ,B.[Level]
        ORDER BY B.[Level]

        SELECT
            1 AS [Level]
            ,Dtc_Id AS Id
            ,DTC_Code AS [Name]
            ,@DtcFactorId AS FactorId
            ,DTC_Name AS AdditionalData
            ,CAST(0 AS BIT) AS IsDefault 
            ,NULL AS ParentId
        FROM 
            (SELECT DISTINCT Dtc_Id FROM #Available_Dtc_Data) tbl
            INNER JOIN Dim_Factor_Dtc dtc ON tbl.Dtc_Id = dtc.ID
        ORDER BY ID


        SELECT
            1 AS [Level]
            ,FactorId AS ID
            ,Label  AS [Name]
            ,@DtcStatusFlag AS FactorId
            ,Null AS AdditionalData
            ,CAST(DefaultValue AS BIT) AS IsDefault 
            ,NULL AS ParentId
        FROM 
            (VALUES (0,'Confirmed',4)) tbl(FactorId,Label,DefaultValue)
        ORDER BY ID
            
        DROP TABLE IF EXISTS #Available_Dtc_Data
    END