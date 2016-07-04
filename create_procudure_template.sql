USE [hrproduct_2015]
GO

/****** Object:  StoredProcedure [dbo].[update_additional_data]    Script Date: 01/16/2015 11:33:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Pengcheng Sun
-- Create date: January 15, 2015
-- Description:	Update additional table
-- =============================================
CREATE PROCEDURE [dbo].[update_additional_data] 
	-- Add the parameters for the stored procedure here
AS
	DECLARE @job_code varchar(50);
	DECLARE @en_script varchar(100);
	DECLARE @script varchar(200);
	
	DECLARE @area_code varchar(50);
	DECLARE @area_desc varchar(50);
	
	DECLARE @cluster_code varchar(50);
	DECLARE @cluster_desc varchar(50);
	
	DECLARE @location_code varchar(50);
	DECLARE @location_desc varchar(50);
	
	DECLARE @dept_code varchar(50);
	DECLARE @dept_desc varchar(50);
BEGIN

	/*************************************************************
		I_JobCode
	*************************************************************/
	INSERT INTO I_JobCode(JobCode)
	SELECT DISTINCT JobCode
	FROM vwEmpDtl_RAW a
	WHERE NOT EXISTS(
		SELECT 1
		FROM I_JobCode b
		WHERE a.JobCode = b.JobCode
	)
	
	DECLARE jobCodeCursor CURSOR FOR
	SELECT JobCode,enscript,script FROM I_JobCode
	OPEN jobCodeCursor
		FETCH NEXT FROM jobCodeCursor into @job_code,@en_script,@script
		WHILE @@FETCH_STATUS = 0
		BEGIN
			UPDATE vwEmpDtl_RAW SET
				enscript = @en_script,
				script = @script
			WHERE JobCode = @job_code
			
			FETCH NEXT FROM jobCodeCursor into @job_code,@en_script,@script
		END
	CLOSE jobCodeCursor
	DEALLOCATE jobCodeCursor
	
	/*************************************************************
		I_Area
	*************************************************************/
	INSERT INTO I_Area(En_Name)
	SELECT DISTINCT DHL_MGMT_AREA
	FROM vwEmpDtl_RAW a
	WHERE NOT EXISTS(
		SELECT 1
		FROM I_Area b
		WHERE a.DHL_MGMT_AREA = b.En_Name
	)
	
	DECLARE areaCursor CURSOR FOR
	SELECT En_Name,Description FROM I_Area
	OPEN areaCursor
		FETCH NEXT FROM areaCursor into @area_code,@area_desc
		WHILE @@FETCH_STATUS = 0
		BEGIN
			UPDATE vwEmpDtl_RAW SET
				Area_Desc = @area_desc
			WHERE DHL_MGMT_AREA = @area_code
			
			FETCH NEXT FROM areaCursor into @area_code,@area_desc
		END
	CLOSE areaCursor
	DEALLOCATE areaCursor
	
	/*************************************************************
		I_Cluster
	*************************************************************/
	INSERT INTO I_Cluster(En_Name)
	SELECT DISTINCT DHL_CLUSTER
	FROM vwEmpDtl_RAW a
	WHERE NOT EXISTS(
		SELECT 1
		FROM I_Cluster b
		WHERE a.DHL_CLUSTER = b.En_Name
	)
	
	DECLARE clusterCursor CURSOR FOR
	SELECT En_Name,Description FROM I_Cluster
	OPEN clusterCursor
		FETCH NEXT FROM clusterCursor into @cluster_code,@cluster_desc
		WHILE @@FETCH_STATUS = 0
		BEGIN
			UPDATE vwEmpDtl_RAW SET
				Cluster_Desc = @cluster_desc
			WHERE DHL_CLUSTER = @cluster_code
			
			FETCH NEXT FROM clusterCursor into @cluster_code,@cluster_desc
		END
	CLOSE clusterCursor
	DEALLOCATE clusterCursor
	
	/*************************************************************
		I_Location
	*************************************************************/
	INSERT INTO I_Location(En_Name)
	SELECT DISTINCT LOCATION
	FROM vwEmpDtl_RAW a
	WHERE NOT EXISTS(
		SELECT 1
		FROM I_Location b
		WHERE a.LOCATION = b.En_Name
	)
	
	DECLARE locationCursor CURSOR FOR
	SELECT En_Name,Description FROM I_Location
	OPEN locationCursor
		FETCH NEXT FROM locationCursor into @location_code,@location_desc
		WHILE @@FETCH_STATUS = 0
		BEGIN
			UPDATE vwEmpDtl_RAW SET
				Location_Desc = @location_desc
			WHERE LOCATION = @location_code
			
			FETCH NEXT FROM locationCursor into @location_code,@location_desc
		END
	CLOSE locationCursor
	DEALLOCATE locationCursor
	 
	/*************************************************************
		I_Department
	*************************************************************/
	INSERT INTO I_Department(En_Name)
	SELECT DISTINCT DEPTGRP
	FROM vwEmpDtl_RAW a
	WHERE NOT EXISTS(
		SELECT 1
		FROM I_Department b
		WHERE a.DEPTGRP = b.En_Name
	)
	
	DECLARE deptCursor CURSOR FOR
	SELECT En_Name,Description FROM I_Department
	OPEN deptCursor
		FETCH NEXT FROM deptCursor into @dept_code,@dept_desc
		WHILE @@FETCH_STATUS = 0
		BEGIN
			UPDATE vwEmpDtl_RAW SET
				Dept_Desc = @dept_desc
			WHERE DEPTGRP = @dept_code
			
			FETCH NEXT FROM deptCursor into @dept_code,@dept_desc
		END
	CLOSE deptCursor
	DEALLOCATE deptCursor
	
END

GO