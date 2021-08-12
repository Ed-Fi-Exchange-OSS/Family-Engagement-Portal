using Unity;
using Unity.Injection;

namespace Student1.ParentPortal.Resources.Tests
{
    internal class BaseTest
    {
        protected UnityContainer Container { get; private set; }
        protected LifeTimeResetter Resetter { get; set; }
        protected BaseTest()
        {
            this.Container = new UnityContainer();
            Resetter = new LifeTimeResetter();
        }

        public void RegisterResettableType<T>(params InjectionMember[] injectionMembers)
        {
           // Container.RegisterType
        }
    }
}
