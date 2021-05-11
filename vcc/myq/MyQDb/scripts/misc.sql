SELECT * FROM sys.objects WHERE name = 'dm_db_log_info'






-- Make the columns not nullable
ALTER TABLE [dbo].[Dim_Dtc_Event_Combinations] ALTER COLUMN [Technical_Model_Year] int NOT NULL;
ALTER TABLE [dbo].[Dim_Dtc_Event_Combinations] ALTER COLUMN [Structure_Week] int NOT NULL;
ALTER TABLE [dbo].[Dim_Dtc_Event_Combinations] ALTER COLUMN [FK_Assembly_Plant_ID] int NOT NULL;
GO

-- Remove FK_ from the name of the columns that are not foreign keys.
EXEC sp_rename 'dbo.Dim_Dtc_Event_Combinations.FK_Assembly_Plant_ID', 'Assembly_Plant_ID', 'COLUMN';
EXEC sp_rename 'dbo.Dim_Dtc_Event_Combinations.FK_Retail_Delivery_Country_Id', 'Retail_Delivery_Country_Id', 'COLUMN';
EXEC sp_rename 'dbo.Dim_Dtc_Event_Combinations.FK_MyQ_PNO_ID', 'MyQ_PNO_ID', 'COLUMN';
GO


-- Build clustered index (just column order as we have no query data to make a data driven decision on). This index is subject to change later on.
CREATE UNIQUE CLUSTERED INDEX [CIX_Dim_Dtc_Event_Combinations_1] 
	ON [dbo].[Dim_Dtc_Event_Combinations] (
	[Technical_Model_Year],
	[Structure_Week],
	[Assembly_Plant_ID],
	[Retail_Delivery_Country_Id],
	[MyQ_PNO_ID],
	[Ecu_Id],
	[Dtc_Id]
) WITH (
	FILLFACTOR=100,			/* We are only adding records in bulk, afterwards we rebuild index. No defragmentation */
	DATA_COMPRESSION=PAGE,  /* Minimize I/O and maximize data in buffer pool */
	SORT_IN_TEMPDB=ON,		/* That's just how we do it */
	ONLINE=ON				/* Do it online */
);

/* Stop and evaluate data compression effectiveness before making other indexes */




CREATE VIEW dbo.vDim_Dtc_Event_Combinations
WITH SCHEMABINDING
AS 
	SELECT 
		Technical_Model_Year, 
		Structure_Week, 
		Assembly_Plant_ID, 
		Retail_Delivery_Country_Id, 
		MyQ_PNO_ID, 
		Ecu_Id, 
		Dtc_Id,
		FK_Dim_Factor_Vehicle_Type_ID, 
		FK_Dim_Factor_Steering_ID, 
		FK_Dim_Factor_Engine_ID, 
		FK_Dim_Factor_Transmission_ID, 
		FK_Dim_Factor_Fuel_Type_ID, 
		FK_Dim_Factor_Propulsion_System_ID, 
		FK_Dim_Factor_Cluster_ID
	FROM 
		[dbo].[Dim_Dtc_Event_Combinations] [dec]
	INNER JOIN [dbo].[Dim_MyQ_PNO] [pno] ON	
		[dec].MyQ_PNO_ID = [pno].ID
	


--DROP INDEX CIX_vDim_Dtc_Event_Combinations ON [dbo].[vDim_Dtc_Event_Combinations]

CREATE UNIQUE CLUSTERED INDEX CIX_vDim_Dtc_Event_Combinations
	ON [dbo].[vDim_Dtc_Event_Combinations]
(
	Technical_Model_Year ASC, 
	Structure_Week ASC, 
	Assembly_Plant_ID ASC, 
	Retail_Delivery_Country_Id ASC, 
	MyQ_PNO_ID ASC,
	Ecu_Id ASC,
	Dtc_Id ASC,
	FK_Dim_Factor_Vehicle_Type_ID ASC, 
	FK_Dim_Factor_Steering_ID ASC, 
	FK_Dim_Factor_Engine_ID ASC, 
	FK_Dim_Factor_Transmission_ID ASC, 
	FK_Dim_Factor_Fuel_Type_ID ASC, 
	FK_Dim_Factor_Propulsion_System_ID ASC, 
	FK_Dim_Factor_Cluster_ID
)
WITH (FILLFACTOR=100, SORT_IN_TEMPDB = ON, DATA_COMPRESSION=PAGE) ON [PRIMARY]
GO


/*Test clustered columnstore index as well */

SELECT *
INTO CCIBASE_Dim_Dtc_Event_Combinations
FROM dbo.vDim_Dtc_Event_Combinations

CREATE CLUSTERED COLUMNSTORE INDEX CCI_Dim_Dtc_Event_Combinations
	ON CCIBASE_Dim_Dtc_Event_Combinations;
