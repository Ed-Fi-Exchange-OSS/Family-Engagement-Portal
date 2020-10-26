using System.Threading.Tasks;
using System.Web.Http;
using Student1.ParentPortal.Resources.Services.Types;

namespace Student1.ParentPortal.Web.Controllers
{
    [RoutePrefix("api/types")]
    public class TypesController : ApiController
    {
        private readonly IAddressTypesService _addressTypesService;
        private readonly IElectronicMailTypesService _electronicMailTypesService;
        private readonly IStateAbbreviationTypesService _stateAbbreviationTypesService;
        private readonly ITelephoneNumberTypesService _telephoneNumberTypesService;
        private readonly ITextMessageCarrierTypesService _textMessageCarrierTypesService;
        private readonly IMethodOfContactTypesService _methodOfContactTypesService;

        public TypesController(IAddressTypesService addressTypesService, IElectronicMailTypesService electronicMailTypesService, IStateAbbreviationTypesService stateAbbreviationTypesService, ITelephoneNumberTypesService telephoneNumberTypesService, ITextMessageCarrierTypesService textMessageCarrierTypesService, IMethodOfContactTypesService methodOfContactTypesService)
        {
            _addressTypesService = addressTypesService;
            _electronicMailTypesService = electronicMailTypesService;
            _stateAbbreviationTypesService = stateAbbreviationTypesService;
            _telephoneNumberTypesService = telephoneNumberTypesService;
            _textMessageCarrierTypesService = textMessageCarrierTypesService;
            _methodOfContactTypesService = methodOfContactTypesService;
        }

        [HttpGet]
        [Route("Address")]
        public async Task<IHttpActionResult> GetAddress()
        {
            var model = await _addressTypesService.GetAddressTypes();
            return Ok(model);
        }

        [HttpGet]
        [Route("ElectronicMail")]
        public async Task<IHttpActionResult> GetElectronicMail()
        {
            var model = await _electronicMailTypesService.GetElectronicMailTypes();
            return Ok(model);
        }

        [HttpGet]
        [Route("StateAbbreviation")]
        public async Task<IHttpActionResult> GetStateAbbreviation()
        {
            var model = await _stateAbbreviationTypesService.GetStateAbbreviationTypes();
            return Ok(model);
        }

        [HttpGet]
        [Route("TelephoneNumber")]
        public async Task<IHttpActionResult> GetTelephoneNumber()
        {
            var model = await _telephoneNumberTypesService.GetTelephoneNumberTypes();
            return Ok(model);
        }

        [HttpGet]
        [Route("TextMessageCarrier")]
        public async Task<IHttpActionResult> GetTextMessageCarrier()
        {
            var model = await _textMessageCarrierTypesService.GetTextMessageCarrierTypes();
            return Ok(model);
        }

        [HttpGet]
        [Route("MethodOfContact")]
        public async Task<IHttpActionResult> GetMethodOfContact()
        {
            var model = await _methodOfContactTypesService.GetMethodOfContactTypes();
            return Ok(model);
        }
    }
}