# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

############################################################

# Author: Douglas Loyo, Sr. Solutions Architect @ MSDF

# Description: Module contains a collection of IO utility functions.

# Note: This powershell has to be ran with Elevated Permissions (As Administrator) and in a x64 environment.

############################################################
Import-Module SQLServer
function Run-DemoDataScripts{
    $EdFiParamTable = @{
                Ods="Server=.; Database=EdFi_Ods_Populated_Template_Test; Trusted_Connection=True;";
                SolutionPath="C:\ed-fi\QuickStarts\FamilyEngagement\ParentPortal-main"
            }
    $OdsConnectStr=$EdFiParamTable.Ods
    $SolutionPath = $EdFiParamTable.SolutionPath
    $DbScriptPath="$SolutionPath\Student1.ParentPortal.Data\Scripts\edFi31"
    Invoke-Sqlcmd -InputFile "$DbScriptPath\1CreateParentPortalSupportingDatabaseSchema.sql"  -ConnectionString $OdsConnectStr
    Invoke-Sqlcmd -InputFile "$DbScriptPath\2ODSExtensions.sql"  -ConnectionString $OdsConnectStr
    Invoke-Sqlcmd -InputFile "$DbScriptPath\3StudentDetails.sql"  -ConnectionString $OdsConnectStr
    Invoke-Sqlcmd -InputFile "$DbScriptPath\4SampleDataDemo.sql"  -ConnectionString $OdsConnectStr


}
