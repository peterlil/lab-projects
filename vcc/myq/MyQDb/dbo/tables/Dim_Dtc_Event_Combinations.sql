CREATE TABLE [dbo].[Dim_Dtc_Event_Combinations](
	[Technical_Model_Year] [int] NOT NULL,
	[Structure_Week] [int] NOT NULL,
	[Assembly_Plant_ID] [int] NOT NULL,
	[Retail_Delivery_Country_Id] [int] NOT NULL,
	[MyQ_PNO_ID] [int] NOT NULL,
	[Ecu_Id] [int] NOT NULL,
	[Dtc_Id] [int] NOT NULL
) ON [PRIMARY]

GO

CREATE UNIQUE CLUSTERED INDEX [CIX_Dim_Dtc_Event_Combinations_1] 
	ON [dbo].[Dim_Dtc_Event_Combinations] (
	[Technical_Model_Year],
	[Structure_Week],
	[Assembly_Plant_ID],
	[Retail_Delivery_Country_Id],
	[MyQ_PNO_ID],
	[Ecu_Id],
	[Dtc_Id]
) WITH (FILLFACTOR=100, DATA_COMPRESSION=PAGE, SORT_IN_TEMPDB=ON,ONLINE=ON);
