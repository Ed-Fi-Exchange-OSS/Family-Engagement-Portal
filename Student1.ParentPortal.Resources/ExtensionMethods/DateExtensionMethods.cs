// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;

namespace Student1.ParentPortal.Resources.ExtensionMethods
{
    public static class DateExtensionMethods
    {
        public static bool IsToday(this DateTime datetime1)
        {
            return datetime1.Year == DateTime.Today.Year
                && datetime1.Month == DateTime.Today.Month
                && datetime1.Day == DateTime.Today.Day;
        }

        public static DateTime FirstHourOfTheDay(this DateTime dt)
        {
            return dt.Date;
        }

        public static DateTime LastHourOfTheDay(this DateTime dt)
        {
            return dt.FirstHourOfTheDay().AddDays(1).AddTicks(-1);
        }

        /// <summary>
        /// Computes the start of the week date given a date and the day of week the week starts on.
        /// </summary>
        /// <param name="dt">The date to compute from</param>
        /// <param name="startOfWeek">The week day to consider the start of week.</param>
        /// <returns>The date that the week starts on.</returns>
        public static DateTime StartOfWeek(this DateTime dt, DayOfWeek startOfWeek)
        {
            int diff = (7 + (dt.DayOfWeek - startOfWeek)) % 7;
            return dt.AddDays(-1 * diff).Date;
        }

        /// <summary>
        /// Computes the end of the week date given a date and the day of week the week ends on.
        /// </summary>
        /// <param name="dt">The date to compute from</param>
        /// <param name="endOfWeek">The week day to consider the end of week.</param>
        /// <returns>The date that the week ends on.</returns>
        public static DateTime EndOfWeek(this DateTime dt, DayOfWeek endOfWeek)
        {
            int diff = (7 + (endOfWeek - dt.DayOfWeek)) % 7;
            return dt.AddDays(diff).Date;
        }

        /// <summary>
        /// Computes the Monday that falls in the week of the given date based on a Sunday start of week.
        /// </summary>
        /// <param name="dt">The date to compute from</param>
        /// <returns>The Monday of the week the given date falls under.</returns>
        public static DateTime GetMonday(this DateTime dt)
        {
            return dt.StartOfWeek(DayOfWeek.Sunday).AddDays(1);
        }

        /// <summary>
        /// Computes the Friday that falls in the week of the given date based on a Saturday end of week.
        /// </summary>
        /// <param name="dt">The date to compute from</param>
        /// <returns>The Friday of the week the given date falls under.</returns>
        public static DateTime GetFriday(this DateTime dt)
        {
            return dt.EndOfWeek(DayOfWeek.Saturday).AddDays(-1);
        }

        public static DateTime SetTimeOnDate(this TimeSpan time, DateTime dt)
        {
            return new DateTime(dt.Year, dt.Month, dt.Day, time.Hours, time.Minutes, time.Seconds);
        }
    }
}
