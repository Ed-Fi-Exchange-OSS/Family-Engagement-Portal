using Microsoft.IdentityModel.Tokens;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Resources.Providers.Configuration;
using Student1.ParentPortal.Resources.Providers.Security;
using Student1.ParentPortal.Resources.Services;
using Student1.ParentPortal.Web.Controllers.OAuth.Admin;
using Student1.ParentPortal.Web.Filters;
using Student1.ParentPortal.Web.Security;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Authentication;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;

namespace Student1.ParentPortal.Web.Controllers.OAuth
{
    [RoutePrefix("OAuth")]
    public class OAuthController : ApiController
    {
        private readonly IApplicationSettingsProvider _config;
        private readonly IDatabaseIdentityProvider _databaseIdentityProvider;

        public OAuthController(IApplicationSettingsProvider appConfig,IDatabaseIdentityProvider databaseIdentityProvider)
        {
            _config = appConfig;
            _databaseIdentityProvider = databaseIdentityProvider;
        }

        // POST: ~/OAuth/ExchangeToken
        [HttpPost]
        [Route("ExchangeToken")]
        [AllowAnonymous]
        public async Task<IHttpActionResult> ExchangeToken(OAuthRequest request)
        {
            var person = await ValidateJwt(request.Client_Token);

            if (person == null)
                return Unauthorized();

            // If we are still here we have a token from a trusted identity provider.
            // TODO: lets get a person details from our ODS database.
            //var jwtKey = TextEncodings.Base64Url.Decode(_config.GetSetting"Jwt:Key"]);
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config.GetSetting("Jwt:Key")));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
            var expiresInMinutes = Convert.ToInt32(_config.GetSetting("Jwt:ExpiresInMinutes"));

            var token = new JwtSecurityToken(
                _config.GetSetting("Jwt:Issuer"),
                _config.GetSetting("Jwt:Audience"),
                expires: DateTime.Now.AddMinutes(expiresInMinutes),
                claims: GetClaims(person),
                signingCredentials: creds
            );

            var model = new OAuthResponse
            {
                Access_token = await Task.Run(() => new JwtSecurityTokenHandler().WriteToken(token)),
                Expires_in = expiresInMinutes * 60,
                Token_type = "Bearer"
            };

            return Ok(model);
        }

        [HttpGet]
        [Route("user/experience")]
        [AllowAnonymous]
        public async Task<IHttpActionResult> GetUserDemoForApple() 
        {
            var email = _config.GetSetting("authentication.apple.testUser");
            var person = await _databaseIdentityProvider.GetPersonInformationAsync(email);
            // If we are still here we have a token from a trusted identity provider.
            // TODO: lets get a person details from our ODS database.
            //var jwtKey = TextEncodings.Base64Url.Decode(_config.GetSetting"Jwt:Key"]);
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config.GetSetting("Jwt:Key")));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
            var expiresInMinutes = Convert.ToInt32(_config.GetSetting("Jwt:ExpiresInMinutes"));

            var token = new JwtSecurityToken(
                _config.GetSetting("Jwt:Issuer"),
                _config.GetSetting("Jwt:Audience"),
                expires: DateTime.Now.AddMinutes(expiresInMinutes),
                claims: GetClaims(person),
                signingCredentials: creds
            );
            var model = new OAuthResponse
            {
                Access_token = await Task.Run(() => new JwtSecurityTokenHandler().WriteToken(token)),
                Expires_in = expiresInMinutes * 60,
                Token_type = "Bearer"
            };

            return Ok(model);
        }



        [HttpPost]
        [Route("ImpersonExchangeToken")]
        public async Task<IHttpActionResult> ImpersonatingToken(OAuthAdminRequest request)
        {
            var identity = SecurityPrincipal.Current;

            if (identity == null)
                return Unauthorized();

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config.GetSetting("Jwt:Key")));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
            var expiresInMinutes = Convert.ToInt32(_config.GetSetting("Jwt:ExpiresInMinutes"));

            var _claims = await GetClaimsForImpersonating(request.ImpersonateEmail);

            var token = new JwtSecurityToken(
                _config.GetSetting("Jwt:Issuer"),
                _config.GetSetting("Jwt:Audience"),
                expires: DateTime.Now.AddMinutes(expiresInMinutes),
                claims: _claims,
                signingCredentials: creds
            );

            var model = new OAuthAdminResponse
            {
                token = await Task.Run(() => new JwtSecurityTokenHandler().WriteToken(token)),
                impersonatingRole = _claims.SingleOrDefault(x => x.Type == "role").Value
            };

            return Ok(model);
        }

        [HttpGet]
        [Route("Apple/.well-known/openid-configuration")]
        [AllowAnonymous]
        public IHttpActionResult AppleOIDCMetadata()
        {
            var metadata = new
            {
                issuer = "https://appleid.apple.com",
                authorization_endpoint = "https://appleid.apple.com/auth/authorize",
                token_endpoint = "https://appleid.apple.com/auth/token",
                jwks_uri = "https://appleid.apple.com/auth/keys"
            };

            return Ok(metadata);
        }
        private IEnumerable<Claim> GetClaims(SecurityPrincipal principal)
        {
            var claims = new List<Claim> {
                new Claim("person_usi", principal.PersonUSI.ToString(), ClaimValueTypes.Integer),
                new Claim("person_type_id", principal.PersonTypeId.ToString(), ClaimValueTypes.Integer),
                new Claim("person_unique_id", principal.PersonUniqueId.ToString(), ClaimValueTypes.String),
                new Claim("role", principal.Role, ClaimValueTypes.String),
                new Claim("email", principal.Email, ClaimValueTypes.String),
                new Claim("firstname", principal.FirstName, ClaimValueTypes.String),
                new Claim("lastsurname", principal.LastSurname, ClaimValueTypes.String)
            };

            return claims;
        }

        private IEnumerable<Claim> GetClaims(PersonIdentityModel person)
        {
            var claims = new List<Claim> {
                new Claim("person_usi", person.Usi.ToString(), ClaimValueTypes.Integer),
                new Claim("person_type_id", person.PersonTypeId.ToString(), ClaimValueTypes.Integer),
                new Claim("person_unique_id", person.UniqueId.ToString(), ClaimValueTypes.String),
                new Claim("role", person.PersonType, ClaimValueTypes.String),
                new Claim("emails", person.Email, ClaimValueTypes.String),
                new Claim("firstname", person.FirstName, ClaimValueTypes.String),
                new Claim("lastsurname", person.LastSurname, ClaimValueTypes.String)
            };

            return claims;
        }

        private async Task<IEnumerable<Claim>> GetClaimsForImpersonating(string email)
        {
            var person = await _databaseIdentityProvider.GetPersonInformationAsync(email);

            var claims = new List<Claim> {
                new Claim("person_usi", person.Usi.ToString(), ClaimValueTypes.Integer),
                new Claim("person_type_id", person.PersonTypeId.ToString(), ClaimValueTypes.Integer),
                new Claim("person_unique_id", person.UniqueId.ToString(), ClaimValueTypes.String),
                new Claim("role", person.PersonType, ClaimValueTypes.String),
                new Claim("email", email, ClaimValueTypes.String),
                new Claim("firstname", person.FirstName, ClaimValueTypes.String),
                new Claim("lastsurname",  person.LastSurname, ClaimValueTypes.String),
                new Claim("impersonate", "true", ClaimValueTypes.String)
            };

            return claims;
        }

        private async Task<PersonIdentityModel> ValidateJwt(string clientToken)
        {
            string email = string.Empty;
            PersonIdentityModel person = null;

            var handler = new JwtSecurityTokenHandler();
            var jsonToken = handler.ReadToken(clientToken) as JwtSecurityToken;
            var audienceToken = jsonToken.Claims.First(x => x.Type == "aud").Value;
            
            var azureAudienceProvider = _config.GetSetting("authentication.azure.audience");
            var appleAudienceProvider = _config.GetSetting("authentication.apple.audience");
            if (audienceToken == azureAudienceProvider)
            {
                var emailClaim = jsonToken.Claims.FirstOrDefault(x => x.Type == "unique_name");
                if (emailClaim != null)
                    email = emailClaim.Value;
                else
                    email = jsonToken.Claims.FirstOrDefault(x => x.Type == "emails").Value;

                person = await _databaseIdentityProvider.GetPersonInformationAsync(email);

                if (person.Email != email)
                    return null;
            }

            if (audienceToken == appleAudienceProvider)
            {
                email = jsonToken.Claims.FirstOrDefault(x => x.Type == "email").Value;

                person = await _databaseIdentityProvider.GetPersonInformationAsync(email);
            }

            if (person.Email != email)
                return null;

            return person;
        }

    }
}
