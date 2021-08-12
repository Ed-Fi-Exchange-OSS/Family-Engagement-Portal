using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Moq;
using NUnit.Framework;
using Student1.ParentPortal.Data.Models.EdFi31;
using Student1.ParentPortal.Data.Tests.Helpers;
using Student1.ParentPortal.Models.Shared;

namespace Student1.ParentPortal.Data.Tests.Models.EdFi31
{
    [TestFixture]
    public class AdminRepositoryFixtures
    {

        [Test]
        public async Task When_getting_an_admin_identity_with_a_valid_staff_email_should_return_an_admin_identity()
        {
            // Arrange
            // Supplied Data: Setting up our baseline of supplied data.
            string suppliedEmail = "staff@student1.org";
            var suppliedStaff = new List<Staff>
            {
                new Staff{ StaffUsi = 1, StaffUniqueId = "S1", FirstName="Staff", LastSurname="Yolo"},
                new Staff{ StaffUsi = 99, StaffUniqueId = "S99", FirstName="Should be filtered out", LastSurname="X"},
            };

            var suppliedStaffElectronicEmail = new List<StaffElectronicMail>
            {
                new StaffElectronicMail{ StaffUsi = 1, ElectronicMailAddress = suppliedEmail},
                new StaffElectronicMail{ StaffUsi = 99, ElectronicMailAddress = "not@included.com"}
            };

            var suppliedAdmins = new List<Admin>
            {
                new Admin{ ElectronicMailAddress = suppliedEmail},
                new Admin{ ElectronicMailAddress = "really@notIncluded.com"}
            };

            var dbContextMock = new Mock<IEdFi31Context>();

            dbContextMock.Setup(p => p.Staffs).Returns(DbContextMockingHelper.GetAsyncQueryableDbSetMock(suppliedStaff));
            dbContextMock.Setup(p => p.StaffElectronicMails).Returns(DbContextMockingHelper.GetAsyncQueryableDbSetMock(suppliedStaffElectronicEmail));
            dbContextMock.Setup(p => p.Admins).Returns(DbContextMockingHelper.GetAsyncQueryableDbSetMock(suppliedAdmins));

            var edFiContextMock = dbContextMock.Object;

            // Act
            var repoUnderTest = new AdminRepository(edFiContextMock);
            var actualResult = await repoUnderTest.GetAdminIdentityByEmailAsync(suppliedEmail);

            // Assert
            Assert.IsNotNull(actualResult);
            Assert.AreEqual(1,actualResult.Count);

            var expectedStaff = suppliedStaff.Single(x => x.StaffUsi == 1);
            var actualStaff = actualResult.Single();
            Assert.AreEqual(expectedStaff.StaffUsi, actualStaff.Usi);
            Assert.AreEqual(expectedStaff.StaffUniqueId, actualStaff.UniqueId);
            Assert.AreEqual(expectedStaff.FirstName, actualStaff.FirstName);
            Assert.AreEqual(expectedStaff.LastSurname, actualStaff.LastSurname);
            Assert.AreEqual(ChatLogPersonTypeEnum.Staff.Value, actualStaff.PersonTypeId);
            Assert.AreEqual(suppliedEmail, actualStaff.Email);
        }

        [Test]
        public async Task When_getting_an_admin_identity_with_a_valid_parent_email_should_return_an_admin_identity()
        {
            // Arrange
            // Supplied Data: Setting up our baseline of supplied data.

            var suppliedStaff = new List<Staff>();
            var suppliedStaffElectronicEmail = new List<StaffElectronicMail>();

            string suppliedEmail = "parent@student1.org";
            var suppliedParents = new List<Parent>
            {
                new Parent{ ParentUsi = 1, ParentUniqueId = "S1", FirstName="Parent", LastSurname="Perez"},
                new Parent{ ParentUsi = 99, ParentUniqueId = "S99", FirstName="Should be filtered out", LastSurname="X"},
            };

            var suppliedParentElectronicEmail = new List<ParentElectronicMail>
            {
                new ParentElectronicMail{ ParentUsi = 1, ElectronicMailAddress = suppliedEmail},
                new ParentElectronicMail{ ParentUsi = 99, ElectronicMailAddress = "not@included.com"}
            };

            var suppliedAdmins = new List<Admin>
            {
                new Admin{ ElectronicMailAddress = suppliedEmail},
                new Admin{ ElectronicMailAddress = "really@notIncluded.com"}
            };

            var dbContextMock = new Mock<IEdFi31Context>();

            dbContextMock.Setup(p => p.Staffs).Returns(DbContextMockingHelper.GetAsyncQueryableDbSetMock(suppliedStaff));
            dbContextMock.Setup(p => p.StaffElectronicMails).Returns(DbContextMockingHelper.GetAsyncQueryableDbSetMock(suppliedStaffElectronicEmail));

            dbContextMock.Setup(p => p.Parents).Returns(DbContextMockingHelper.GetAsyncQueryableDbSetMock(suppliedParents));
            dbContextMock.Setup(p => p.ParentElectronicMails).Returns(DbContextMockingHelper.GetAsyncQueryableDbSetMock(suppliedParentElectronicEmail));

            dbContextMock.Setup(p => p.Admins).Returns(DbContextMockingHelper.GetAsyncQueryableDbSetMock(suppliedAdmins));

            var edFiContextMock = dbContextMock.Object;

            // Act
            var repoUnderTest = new AdminRepository(edFiContextMock);
            var actualResult = await repoUnderTest.GetAdminIdentityByEmailAsync(suppliedEmail);

            // Assert
            Assert.IsNotNull(actualResult);
            Assert.AreEqual(1, actualResult.Count);

            var expectedParent = suppliedParents.Single(x => x.ParentUsi == 1);
            var actualParent = actualResult.Single();
            Assert.AreEqual(expectedParent.ParentUsi, actualParent.Usi);
            Assert.AreEqual(expectedParent.ParentUniqueId, actualParent.UniqueId);
            Assert.AreEqual(expectedParent.FirstName, actualParent.FirstName);
            Assert.AreEqual(expectedParent.LastSurname, actualParent.LastSurname);
            Assert.AreEqual(ChatLogPersonTypeEnum.Parent.Value, actualParent.PersonTypeId);
            Assert.AreEqual(suppliedEmail, actualParent.Email);
        }

        [Test]
        public async Task When_getting_an_admin_identity_with_a_INVALID_email_should_return_an_empty_list()
        {
            // Arrange
            // Supplied Data: Setting up our baseline of supplied data.
            string suppliedEmail = "invalid@student1.org";
            
            var suppliedStaff = new List<Staff>();
            var suppliedStaffElectronicEmail = new List<StaffElectronicMail>();
            
            var suppliedParents = new List<Parent>();
            var suppliedParentElectronicEmail = new List<ParentElectronicMail>();

            var suppliedAdmins = new List<Admin>();

            var dbContextMock = new Mock<IEdFi31Context>();

            dbContextMock.Setup(p => p.Staffs).Returns(DbContextMockingHelper.GetAsyncQueryableDbSetMock(suppliedStaff));
            dbContextMock.Setup(p => p.StaffElectronicMails).Returns(DbContextMockingHelper.GetAsyncQueryableDbSetMock(suppliedStaffElectronicEmail));
            dbContextMock.Setup(p => p.Parents).Returns(DbContextMockingHelper.GetAsyncQueryableDbSetMock(suppliedParents));
            dbContextMock.Setup(p => p.ParentElectronicMails).Returns(DbContextMockingHelper.GetAsyncQueryableDbSetMock(suppliedParentElectronicEmail));
            dbContextMock.Setup(p => p.Admins).Returns(DbContextMockingHelper.GetAsyncQueryableDbSetMock(suppliedAdmins));

            var edFiContextMock = dbContextMock.Object;

            // Act
            var repoUnderTest = new AdminRepository(edFiContextMock);
            var actualResult = await repoUnderTest.GetAdminIdentityByEmailAsync(suppliedEmail);

            // Assert
            Assert.IsNotNull(actualResult);
            Assert.AreEqual(0, actualResult.Count);
        }
    }
}
