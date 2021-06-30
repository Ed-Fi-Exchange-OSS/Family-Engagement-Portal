using Microsoft.IdentityModel.Protocols;
using Microsoft.IdentityModel.Protocols.OpenIdConnect;
using Microsoft.IdentityModel.Tokens;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Resources.Providers.Configuration;
using Student1.ParentPortal.Resources.Services;
using Student1.ParentPortal.Web.Controllers.OAuth.Admin;
using Student1.ParentPortal.Web.Models;
using Student1.ParentPortal.Web.Security;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net;
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

        [AllowAnonymous]
        [HttpPost]
        [Route("ExchangeToken")]
        public async Task<IHttpActionResult> ExchangeToken(OAuthTokenExchangeRequest request)
        {
            if (request.Grant_type != "client_credentials")
                return BadRequest($"grant_type ({request.Grant_type}) not supported");

            bool token_signed = false;
            string access_token = string.Empty;
            if (request.Service == "facebook" && !string.IsNullOrEmpty(request.Code))
            {
                access_token = ValidateSignatureOther(request.Code, request.Service);
                token_signed = !string.IsNullOrEmpty(access_token);
            }
            else
                token_signed = ValidateSignatureJwt(request.Id_token, request.Service);

            if (!token_signed)
                return Unauthorized();

            PersonIdentityModel person = null;

            if (!string.IsNullOrEmpty(access_token))
                person = await GetPersonInformationByService(access_token, request.Service);
            else
                person = await ValidateJwt(request.Id_token, request.Service);

            if (person == null)
                return Unauthorized();

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

        [AllowAnonymous]
        [HttpGet]
        [Route("GetUrlForSSO")]
        public IHttpActionResult GetUrlForSSO(string service)
        {
            string result = string.Empty;
            if (string.IsNullOrEmpty(service)) return Ok(result);

            switch (service.ToLower())
            {
                case "azure":
                    string azure_tenant = _config.GetSetting("authentication.azure.tenant");
                    string azure_sso = _config.GetSetting("authentication.azure.sso");
                    string azure_clientid = _config.GetSetting("authentication.azure.clientId");
                    string azure_redirecturl = _config.GetSetting("authentication.azure.redirecturl");
                    result = string.Format(azure_sso, azure_tenant, azure_clientid, azure_redirecturl, Guid.NewGuid());
                    break;

                case "google":
                    string google_sso = _config.GetSetting("authentication.google.sso");
                    string google_clientid = _config.GetSetting("authentication.google.clientId");
                    string google_redirecturl = _config.GetSetting("authentication.google.redirecturl");
                    result = string.Format(google_sso, google_redirecturl, google_clientid);
                    break;

                case "hotmail":
                    string hotmail_sso = _config.GetSetting("authentication.hotmail.sso");
                    string hotmail_clientid = _config.GetSetting("authentication.hotmail.clientId");
                    string hotmail_redirecturl = _config.GetSetting("authentication.hotmail.redirecturl");
                    result = string.Format(hotmail_sso, hotmail_clientid, hotmail_redirecturl, Guid.NewGuid());
                    break;

                case "facebook":
                    string facebook_sso = _config.GetSetting("authentication.facebook.sso");
                    string facebook_clientid = _config.GetSetting("authentication.facebook.clientId");
                    string facebook_redirecturl = _config.GetSetting("authentication.facebook.redirecturl");
                    result = string.Format(facebook_sso, facebook_clientid, facebook_redirecturl, Guid.NewGuid());
                    break;
            }

            return Ok(result);
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
                impersonatingRole = _claims.SingleOrDefault(x => x.Type.Contains("role")).Value
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

        private List<Claim> GetClaims(PersonIdentityModel personInfo)
        {
            if (personInfo == null)
                return null;

            var claims = new List<Claim> {
                new Claim(JwtRegisteredClaimNames.GivenName, personInfo.FirstName),
                new Claim(JwtRegisteredClaimNames.FamilyName, personInfo.LastSurname),
                new Claim(JwtRegisteredClaimNames.Email, personInfo.Email),
                
                // Add custom claims
                new Claim("person_usi", personInfo.Usi.ToString(), ClaimValueTypes.Integer),
                new Claim("person_type_id", personInfo.PersonTypeId.ToString(), ClaimValueTypes.Integer),
                new Claim("person_unique_id", personInfo.UniqueId.ToString(), ClaimValueTypes.String),
                new Claim("person_role", personInfo.PersonType, ClaimValueTypes.String),
                new Claim("email", personInfo.Email, ClaimValueTypes.String),
                new Claim("firstname", personInfo.FirstName, ClaimValueTypes.String),
                new Claim("lastsurname", personInfo.LastSurname, ClaimValueTypes.String),
                new Claim("person_identification_code", string.IsNullOrEmpty(personInfo.IdentificationCode) ? string.Empty: personInfo.IdentificationCode, ClaimValueTypes.String)
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
                new Claim("person_role", person.PersonType, ClaimValueTypes.String),
                new Claim("email", email, ClaimValueTypes.String),
                new Claim("firstname", person.FirstName, ClaimValueTypes.String),
                new Claim("lastsurname",  person.LastSurname, ClaimValueTypes.String),
                new Claim("impersonate", "true", ClaimValueTypes.String)
            };

            return claims;
        }

        private async Task<PersonIdentityModel> ValidateJwt(string clientToken, string service)
        {
            string email = string.Empty;
            PersonIdentityModel person = null;

            var handler = new JwtSecurityTokenHandler();
            var jsonToken = handler.ReadToken(clientToken) as JwtSecurityToken;

            switch (service)
            {
                case "google":
                    email = jsonToken.Claims.FirstOrDefault(x => x.Type == "email").Value;
                    break;

                case "azure":
                    var emailClaim = jsonToken.Claims.FirstOrDefault(x => x.Type == "unique_name");
                    if (emailClaim != null)
                        email = emailClaim.Value;
                    else
                        email = jsonToken.Claims.FirstOrDefault(x => x.Type == "emails").Value;
                    break;

                case "hotmail":
                    if (jsonToken.Claims.FirstOrDefault(x => x.Type == "email") != null)
                        email = jsonToken.Claims.FirstOrDefault(x => x.Type == "email").Value;
                    else
                    {
                        var emailClaimH = jsonToken.Claims.FirstOrDefault(x => x.Type == "unique_name");
                        if (emailClaimH != null)
                            email = emailClaimH.Value;
                        else
                            email = jsonToken.Claims.FirstOrDefault(x => x.Type == "emails").Value;
                    }
                    break;
            }

            if (string.IsNullOrEmpty(email)) return null;

            person = await _databaseIdentityProvider.GetPersonInformationAsync(email);

            if (person == null || person.Email.ToUpper() != email.ToUpper())
                return null;

            return person;
        }

        private bool ValidateSignatureJwt(string clientToken, string service)
        {
            bool result = false;
            try
            {
                string stsDiscoveryEndpoint = null;
                switch (service.ToLower())
                {
                    case "azure":
                        string azure_tenant = _config.GetSetting("authentication.azure.tenant");
                        string azure_jwt_token_validation = _config.GetSetting("authentication.azure.url.token.validation");
                        stsDiscoveryEndpoint = string.Format(azure_jwt_token_validation, azure_tenant);
                        break;

                    case "google":
                        stsDiscoveryEndpoint = _config.GetSetting("authentication.google.url.token.validation");
                        break;

                    case "hotmail":
                        stsDiscoveryEndpoint = _config.GetSetting("authentication.hotmail.url.token.validation");
                        break;
                }

                if (string.IsNullOrEmpty(stsDiscoveryEndpoint)) return false;

                ConfigurationManager<OpenIdConnectConfiguration> configManager = new ConfigurationManager<OpenIdConnectConfiguration>(stsDiscoveryEndpoint, new OpenIdConnectConfigurationRetriever());
                OpenIdConnectConfiguration config = configManager.GetConfigurationAsync().Result;
                TokenValidationParameters validationParameters = new TokenValidationParameters
                {
                    IssuerSigningKeys = config.SigningKeys,
                    ValidateAudience = false,
                    ValidateIssuer = false,
                    ValidateLifetime = false
                };

                JwtSecurityTokenHandler tokendHandler = new JwtSecurityTokenHandler();
                SecurityToken jwt;
                ClaimsPrincipal claimsPrincipal = tokendHandler.ValidateToken(clientToken, validationParameters, out jwt);
                JwtSecurityToken jwtSecurityToken = jwt as JwtSecurityToken;

                if (jwt != null && claimsPrincipal != null)
                    result = true;
            }
            catch
            {
            }
            return result;
        }

        private string ValidateSignatureOther(string code, string service)
        {
            string access_token = string.Empty;
            try
            {
                string url = string.Empty;
                switch (service)
                {
                    case "facebook":
                        string facebook_token_validation = _config.GetSetting("authentication.facebook.url.token.validation");
                        string facebook_clientid = _config.GetSetting("authentication.facebook.clientId");
                        string facebook_clientSecret = _config.GetSetting("authentication.facebook.clientSecret");
                        string facebook_redirecturl = _config.GetSetting("authentication.facebook.redirecturl");
                        url = string.Format(facebook_token_validation, facebook_clientid, facebook_redirecturl, facebook_clientSecret, code);
                        break;
                }

                WebClient client = new WebClient();
                string reply = client.DownloadString(url);
                if (!string.IsNullOrEmpty(reply))
                {
                    FacebookResponse response = Newtonsoft.Json.JsonConvert.DeserializeObject<FacebookResponse>(reply);
                    access_token = response.access_token;
                }
            }
            catch
            {
            }
            return access_token;
        }

        private async Task<PersonIdentityModel> GetPersonInformationByService(string access_token, string service)
        {
            string email = string.Empty, url = string.Empty;
            PersonIdentityModel person;

            switch (service)
            {
                case "facebook":
                    string facebook_url_info = _config.GetSetting("authentication.facebook.url.extract.information");
                    url = string.Format(facebook_url_info, access_token);
                    break;
            }

            if (string.IsNullOrEmpty(url)) return null;

            WebClient client = new WebClient();
            string reply = client.DownloadString(url);
            if (!string.IsNullOrEmpty(reply))
            {
                FacebookResponse response = Newtonsoft.Json.JsonConvert.DeserializeObject<FacebookResponse>(reply);
                email = response.email;
            }

            if (string.IsNullOrEmpty(email)) return null;
            person = await _databaseIdentityProvider.GetPersonInformationAsync(email);

            if (person == null || person.Email != email)
                return null;

            return person;
        }
    }
}
