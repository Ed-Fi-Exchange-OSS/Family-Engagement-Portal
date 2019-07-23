using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Security.Principal;
using System.Threading;
using System.Web;

namespace Student1.ParentPortal.Web.Security
{
    public class SecurityPrincipal : ClaimsPrincipal
    {
        public SecurityPrincipal(IIdentity identity) : base(identity)
        {
        }

        public new static SecurityPrincipal Current
        {
            get
            {
                var claimsPrincipal = Thread.CurrentPrincipal as ClaimsPrincipal;

                if (claimsPrincipal == null)
                    return null;

                var securityPrincipal = new SecurityPrincipal(claimsPrincipal.Identities.First());

                return securityPrincipal;
            }
        }

        /// <summary>
        /// The Unique State Identifier for a person.
        /// </summary>
        public int PersonUSI
        {
            get { return Convert.ToInt32(Current.Claims.FirstOrDefault(x => x.Type == "person_usi").Value); }
        }

        /// <summary>
        /// The database unique identifier for a person.
        /// </summary>
        public string PersonUniqueId
        {
            get { return Current.Claims.FirstOrDefault(x => x.Type == "person_unique_id").Value; }
        }
        public int PersonTypeId
        {
            get { return Convert.ToInt32(Current.Claims.FirstOrDefault(x => x.Type == "person_type_id").Value); }
        }
        public string Role
        {
            get { return Current.Claims.FirstOrDefault(x => x.Type == "role").Value; }
        }

        public string Email
        {
            get { return Current.Claims.FirstOrDefault(x => x.Type == "email").Value; }
        }

        public string FirstName
        {
            get { return Current.Claims.FirstOrDefault(x => x.Type == "firstname").Value; }
        }

        public string LastSurname
        {
            get { return Current.Claims.FirstOrDefault(x => x.Type == "lastsurname").Value; }
        }
    }
}