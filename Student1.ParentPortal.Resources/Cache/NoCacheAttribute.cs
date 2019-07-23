using System;

namespace Student1.ParentPortal.Resources.Cache
{
    [AttributeUsage(AttributeTargets.All)]
    public class NoCacheAttribute : Attribute
    {
        // Placeholder attribute to indicate that this class or method should not be cached.
    }
}
