// SPDX-License-Identifier: Apache-2.0
// Licensed to the Ed-Fi Alliance under one or more agreements.
// The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
// See the LICENSE and NOTICES files in the project root for more information.

using System;
using System.Collections;
using System.Collections.Concurrent;
using System.Linq;
using System.Reflection;
using System.Text;

namespace Student1.ParentPortal.Web.Infrastructure.Cache
{
    public interface ICacheKeyProvider
    {
        string GenerateCacheKey(MethodBase methodInvocationTarget, object[] arguments);
    }

    public class CacheKeyProvider : ICacheKeyProvider
    {
        private const string Delimiter = "|";
        private const string NullWithDelimiter = "null|";

        public string GenerateCacheKey(MethodBase methodInvocationTarget, object[] arguments)
        {
            var sb = new StringBuilder();

            sb.Append(GetCacheKeyPrefix(methodInvocationTarget));

            foreach (var arg in arguments)
            {
                if (arg == null)
                {
                    sb.Append(NullWithDelimiter);
                    continue;
                }

                //We can only cache/build a cache Key for ValueTypes and Objects that have properties that are ValueTypes.
                if (!(arg.GetType().IsValueType || arg is string))
                {
                    AppendParameterNameValueString(sb, arg);
                }
                else
                {
                    sb.Append(arg.GetHashCode());
                    sb.Append(Delimiter);
                }

            }

            return sb.ToString();
        }

        private static ConcurrentDictionary<MethodBase, string> cacheKeyPrefixByMethodInfo = new ConcurrentDictionary<MethodBase, string>();

        private static string GetCacheKeyPrefix(MethodBase invocationTarget)
        {
            return cacheKeyPrefixByMethodInfo.GetOrAdd(invocationTarget,
                i => $"{i.DeclaringType.FullName}.{invocationTarget.Name}(");
        }

        private static ConcurrentDictionary<Type, PropertyInfo[]> propertiesByType = new ConcurrentDictionary<Type, PropertyInfo[]>();

        private static PropertyInfo[] GetProperties(Type type)
        {
            return propertiesByType.GetOrAdd(type, t => t.GetProperties());
        }

        public static void AppendParameterNameValueString<T>(StringBuilder stringBuilder, T obj)
        {
            // Is this a list, array or any type of collection?
            var enumerable = obj as IEnumerable;
            if (enumerable != null)
            {
                var sbEnumItems = new StringBuilder();

                foreach (var i in enumerable)
                {
                    sbEnumItems.Append(i.GetHashCode());
                    sbEnumItems.Append("|");
                }
                stringBuilder.AppendFormat($"col:{sbEnumItems}");
            }

            var objectProperties = GetProperties(obj.GetType()).Where(p => p.GetIndexParameters().Length == 0); ;

            foreach (var objectProperty in objectProperties)
            {
                var value = objectProperty.GetValue(obj,null);

                if (objectProperty.PropertyType.IsValueType || objectProperty.PropertyType == typeof(string))
                    stringBuilder.AppendFormat("{0}:{1},", objectProperty.Name, value);
                else if (value != null)
                {
                    var collection = value as IEnumerable;
                    if (collection != null)
                    {
                        var sbEnumItems = new StringBuilder();

                        foreach (var i in collection)
                        {
                            sbEnumItems.Append(i.GetHashCode());
                            sbEnumItems.Append("|");
                        }
                        stringBuilder.AppendFormat("{0}:{1}", objectProperty.Name, sbEnumItems.ToString());
                    }
                    else
                    {
                        stringBuilder.AppendFormat("{0}:{1},", objectProperty.Name, value.GetHashCode());
                    }
                }
                else
                    stringBuilder.AppendFormat("{0}:null,", objectProperty.Name);
            }
        }
    }
}