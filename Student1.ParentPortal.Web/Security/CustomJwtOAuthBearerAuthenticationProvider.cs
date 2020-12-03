using System;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.Owin.Security.OAuth;
using Student1.ParentPortal.Resources.Services;

namespace Student1.ParentPortal.Web.Security
{
    public class CustomJwtOAuthBearerAuthenticationProvider : OAuthBearerAuthenticationProvider, IOAuthBearerAuthenticationProvider
    {
        private readonly IDatabaseIdentityProvider _databaseIdentityProvider;

        public CustomJwtOAuthBearerAuthenticationProvider(IDatabaseIdentityProvider databaseIdentityProvider)
        {
            _databaseIdentityProvider = databaseIdentityProvider;
        }

        public override async Task ValidateIdentity(OAuthValidateIdentityContext context)
        {
            // Validate all base things first.
            await base.ValidateIdentity(context);

            // *NOTE: It is important to note that because we are using JWT pipeline already does the
            // conversion of the token to the context. This means that our token already has the claims we
            // issued in the OAuthController. These claims are the ones we need in our application.
            // This CustomJwtOAuthBearerAuthenticationProvider allows us, if needed, to add extra claims.
            // As of today we do not need any extra claims.
            //var claims = context.Ticket.Identity.Claims;

            //// Add custom claims
            //context.Ticket.Identity.AddClaim(new Claim("person_usi", person.Usi.ToString(), ClaimValueTypes.Integer));
            //context.Ticket.Identity.AddClaim(new Claim("person_type_id", person.PersonTypeId.ToString(), ClaimValueTypes.Integer));
            //context.Ticket.Identity.AddClaim(new Claim("person_unique_id", person.UniqueId.ToString(), ClaimValueTypes.String));
            //context.Ticket.Identity.AddClaim(new Claim("role", person.PersonType, ClaimValueTypes.String));
            //context.Ticket.Identity.AddClaim(new Claim("email", identityEmail, ClaimValueTypes.String));
            //context.Ticket.Identity.AddClaim(new Claim("firstname", person.FirstName, ClaimValueTypes.String));
            //context.Ticket.Identity.AddClaim(new Claim("lastsurname", person.LastSurname, ClaimValueTypes.String));
        }
    }
}