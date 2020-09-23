// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Resources.Providers.Security.Access
{
    public class SecurityContext
    {
        public int UserUSIAccessingResource { get; set; }
        public string UserRoleAccessingResource { get; set; }
        public int? StudentUSI { get; set; }
        /// <summary>
        /// The name of the resource being accessed. 
        /// In this case its the API endpoint\controller
        /// </summary>
        public string ResourceName { get; set; }
        public string ActionName { get; set; }
        public Dictionary<string,object> ActionParameters { get; set; }
    }
}
