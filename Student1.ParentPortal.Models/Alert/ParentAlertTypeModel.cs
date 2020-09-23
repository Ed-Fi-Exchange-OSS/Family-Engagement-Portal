// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Student1.ParentPortal.Models.Alert
{
    public class ParentAlertTypeModel
    {
        public ParentAlertTypeModel()
        {
            Alerts = new List<AlertTypeModel>();
        }
        public bool AlertsEnabled { get; set; }
        public ICollection<AlertTypeModel> Alerts { get; set; }
    }
    public class AlertTypeModel
    {
        public AlertTypeModel()
        {
            Thresholds = new List<ThresholdTypeModel>();
        }
        public int AlertTypeId { get; set; }
        public bool? Enabled { get; set; }
        public string Description { get; set; }
        public string ShortDescription { get; set; }
        public ICollection<ThresholdTypeModel> Thresholds { get; set; }
    }

    public class ThresholdTypeModel{
        public int ThresholdTypeId { get; set; }
        public decimal ThresholdValue { get; set; }
        public string Description { get; set; }
        public string ShortDescription { get; set; }
        public string WhatCanParentDo { get; set; }
    }
}
