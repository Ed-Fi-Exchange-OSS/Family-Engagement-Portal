namespace Student1.ParentPortal.Web.Controllers.OAuth
{
    public class OAuthTokenExchangeRequest
    {
        public string Id_token { get; set; }
        public string Grant_type { get; set; }
        public string Service { get; set; }
        public string Code { get; set; }
    }
}