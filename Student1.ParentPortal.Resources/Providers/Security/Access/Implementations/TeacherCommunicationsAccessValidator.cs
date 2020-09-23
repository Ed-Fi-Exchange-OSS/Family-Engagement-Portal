// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Linq;
using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Models.Chat;

namespace Student1.ParentPortal.Resources.Providers.Security.Access
{
    public class TeacherCommunicationsAccessValidator : IRoleResourceAccessValidator
    {
        private readonly ITeacherRepository _teacherRepository;

        public TeacherCommunicationsAccessValidator(ITeacherRepository parentRepository)
        {
            _teacherRepository = parentRepository;
        }

        public bool CanHandle(SecurityContext securityContext)
        {
            return securityContext.UserRoleAccessingResource.Equals("staff", StringComparison.InvariantCultureIgnoreCase)
                && securityContext.ResourceName.Equals("communications", StringComparison.InvariantCultureIgnoreCase);
        }

        public bool CanAccess(SecurityContext securityContext)
        {
            var studentUsi = GetStudentUsiFromContext(securityContext);
            var studentUniqueId = GetStudentUniqueIdFromContext(securityContext);
            var staffUsi = securityContext.UserUSIAccessingResource;

            if (studentUsi != 0)
                // Only direct Student Parent Associations.
                return _teacherRepository.HasAccessToStudent(staffUsi, studentUsi);
            else if (studentUniqueId != null)
                return _teacherRepository.HasAccessToStudent(staffUsi, studentUniqueId);
            else if(studentUsi == 0)
                return true;
            else
                throw new NotImplementedException("Can't extract studentUSI or studentUniqueId from the request." + string.Join(",", securityContext.ActionParameters.Keys));
        }

        private int GetStudentUsiFromContext(SecurityContext securityContext)
        {
            // TODO: Refactor this into models implementing IStudent { int StudentUsi } so that its more generic.
            if(securityContext.ActionParameters.ContainsKey("studentUsi"))
                return Convert.ToInt32(securityContext.ActionParameters.Single(x => x.Key == "studentUsi").Value);

            if (securityContext.ActionParameters.ContainsKey("request"))
            {
                var request = securityContext.ActionParameters.Single(x => x.Key == "request").Value as ChatThreadRequestModel;
                if (request != null)
                    return request.StudentUsi;
            }

            return 0;
        }

        private string GetStudentUniqueIdFromContext(SecurityContext securityContext)
        {
            if (securityContext.ActionParameters.ContainsKey("chatLogItemModel"))
            {
                var request = securityContext.ActionParameters.Single(x => x.Key == "chatLogItemModel").Value as ChatLogItemModel;
                if (request != null)
                    return request.StudentUniqueId;
            }
            return null;
        }
    }
}
