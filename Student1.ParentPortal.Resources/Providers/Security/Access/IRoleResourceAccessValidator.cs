namespace Student1.ParentPortal.Resources.Providers.Security.Access
{
    public interface IRoleResourceAccessValidator
    {
        bool CanHandle(SecurityContext securityContext);
        bool CanAccess(SecurityContext securityContext);
    }
}
