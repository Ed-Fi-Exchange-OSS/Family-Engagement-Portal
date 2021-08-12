using System.Collections.Generic;
using System.Threading.Tasks;
using Moq;
using NUnit.Framework;
using SimpleInjector;
using Student1.ParentPortal.Data.Models;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Resources.Providers.Configuration;
using Student1.ParentPortal.Resources.Providers.Security;

namespace Student1.ParentPortal.Resources.Tests
{
    public class StaffIdentityProviderTest
    {
        [Test]
        public async Task When_getting_an_identity_for_staff_with_an_invalid_email_should_return_null()
        {
            //Arrange
            var mockContainer = new Container();
            var mockStaffRepository = new Mock<IStaffRepository>();
            List<PersonIdentityModel> suppliedData = null;
            mockStaffRepository.Setup(r => r.GetStaffIdentityByEmailAsync(It.IsAny<string>(), It.IsAny<string[]>())).Returns(Task.FromResult(suppliedData));
            mockStaffRepository.Setup(r => r.GetStaffIdentityByProfileEmailAsync(It.IsAny<string>(), It.IsAny<string[]>())).Returns(Task.FromResult(suppliedData));
            mockContainer.RegisterInstance(typeof(IStaffRepository), mockStaffRepository.Object);

            var mockCustomParametersProvider = new Mock<ICustomParametersProvider>();
            var suppliedCustomParams = new CustomParameters { descriptors = new Descriptors { validStaffDescriptors = It.IsAny<string[]>() } };
            mockCustomParametersProvider.Setup(cp => cp.GetParameters()).Returns(suppliedCustomParams);


            var providerUnderTest = new StaffIdeintityProvider(mockContainer, mockCustomParametersProvider.Object);

            // ACT
            var actualResult = await providerUnderTest.GetIdentity("");

            //Assert
            Assert.IsNull(actualResult);
        }

        ////Create the other scenario with a valid email.
        ///
        [Test]
        public async Task When_getting_an_identity_for_staff_with_a_valid_email_should_return_object()
        {
            //Arrange
            var mockContainer = new Container();
            var mockStaffRepository = new Mock<IStaffRepository>();
            List<PersonIdentityModel> suppliedData = new List<PersonIdentityModel>();

            suppliedData.Add(new PersonIdentityModel
            {
                Email = "karenjohson2222@gmail.com",
                FirstName = "Karen",
                LastSurname = "Jhonson",
                PersonType = "Staff",
            });

            mockStaffRepository.Setup(r => r.GetStaffIdentityByEmailAsync(It.IsAny<string>(), It.IsAny<string[]>())).Returns(Task.FromResult(suppliedData));
            mockStaffRepository.Setup(r => r.GetStaffIdentityByProfileEmailAsync(It.IsAny<string>(), It.IsAny<string[]>())).Returns(Task.FromResult(suppliedData));
            mockContainer.RegisterInstance(typeof(IStaffRepository), mockStaffRepository.Object);

            var mockCustomParametersProvider = new Mock<ICustomParametersProvider>();
            var suppliedCustomParams = new CustomParameters { descriptors = new Descriptors { validStaffDescriptors = It.IsAny<string[]>() } };
            mockCustomParametersProvider.Setup(cp => cp.GetParameters()).Returns(suppliedCustomParams);


            var providerUnderTest = new StaffIdeintityProvider(mockContainer, mockCustomParametersProvider.Object);

            // ACT
            var actualResult = await providerUnderTest.GetIdentity("karenjohson2222@gmail.com");

            //Assert
            Assert.AreEqual(actualResult.PersonType,"Staff");
        }
    }
}
