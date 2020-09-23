// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Shared
{
    public class ChatLogPersonTypeEnum : Enumeration<ChatLogPersonTypeEnum>
    {
        public static readonly ChatLogPersonTypeEnum Parent = new ChatLogPersonTypeEnum(1, "Parent");
        public static readonly ChatLogPersonTypeEnum Staff = new ChatLogPersonTypeEnum(2, "Staff");

        private ChatLogPersonTypeEnum(int value, string displayName) : base(value, displayName)
        {
        }
    }
}
