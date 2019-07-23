using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
using Microsoft.Owin.Security.OAuth;
using Student1.ParentPortal.Resources.Services;

namespace Student1.ParentPortal.Web.Security
{
    public class CustomAzureAdOAuthBearerAuthenticationProvider : OAuthBearerAuthenticationProvider
    {
        private readonly IDatabaseIdentityProvider _databaseIdentityProvider;

        public CustomAzureAdOAuthBearerAuthenticationProvider(IDatabaseIdentityProvider databaseIdentityProvider)
        {
            _databaseIdentityProvider = databaseIdentityProvider;
        }

        public override async Task ValidateIdentity(OAuthValidateIdentityContext context)
        {
            // Validate all base things first.
            await base.ValidateIdentity(context);

            // For Azure AD B2B the email is stored in the "UPN User Principal Name" claim or the "Email" one.
            var emailClaim = context.Ticket.Identity.Claims.FirstOrDefault(x => x.Type == ClaimTypes.Upn);

            if (emailClaim == null)
                emailClaim = context.Ticket.Identity.Claims.FirstOrDefault(x => x.Type == ClaimTypes.Email);

            // For Azure Ad B2C the email is stored in the "emails" collection.
            if (emailClaim == null)
                emailClaim = context.Ticket.Identity.Claims.FirstOrDefault(x => x.Type == "emails");

            if (emailClaim == null)
                throw new NotImplementedException("Cant find the email claim.");

            var identityEmail = emailClaim.Value;

            // Get the person details
            var person = await _databaseIdentityProvider.GetPersonInformationAsync(identityEmail);

            // Add custom claims
            context.Ticket.Identity.AddClaim(new Claim("person_usi",person.Usi.ToString(),ClaimValueTypes.Integer));
            context.Ticket.Identity.AddClaim(new Claim("person_type_id", person.PersonTypeId.ToString(), ClaimValueTypes.Integer));
            context.Ticket.Identity.AddClaim(new Claim("person_unique_id",person.UniqueId.ToString(),ClaimValueTypes.String));
            context.Ticket.Identity.AddClaim(new Claim("role",person.PersonType,ClaimValueTypes.String));
            context.Ticket.Identity.AddClaim(new Claim("email",identityEmail,ClaimValueTypes.String));
            context.Ticket.Identity.AddClaim(new Claim("firstname", person.FirstName, ClaimValueTypes.String));
            context.Ticket.Identity.AddClaim(new Claim("lastsurname", person.LastSurname, ClaimValueTypes.String));
        }
    }
}