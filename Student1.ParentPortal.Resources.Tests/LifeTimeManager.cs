using System;
using Unity.Lifetime;

namespace Student1.ParentPortal.Resources.Tests
{
    public class LifeTimeResetter
    {
        public event EventHandler<EventArgs> OnReset;
        public void Reset()
        {
            OnReset?.Invoke(this, EventArgs.Empty);
        }
    }
    public class ResettableLifetimeManager : LifetimeManager
    {

        private object instance;
        public ResettableLifetimeManager(LifeTimeResetter lifeTimeResetter)
        {
            lifeTimeResetter.OnReset += (o, args) => instance = null;
        }
        protected override LifetimeManager OnCreateLifetimeManager()
        {
            throw new NotImplementedException();
        }
        public override object GetValue(ILifetimeContainer container = null)
        {
            return instance;
        }
        public override void SetValue(object newValue, ILifetimeContainer container = null)
        {
            instance = newValue;
        }
    }
}
