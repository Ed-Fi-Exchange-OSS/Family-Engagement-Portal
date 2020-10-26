namespace Student1.ParentPortal.Resources.Providers.Cache
{
    public interface ICacheProvider
    {
        object Get(string key);
        T Get<T>(string key) where T : class;
        void Set<T>(string key, T result) where T : class;
        void Clear();
    }
}
