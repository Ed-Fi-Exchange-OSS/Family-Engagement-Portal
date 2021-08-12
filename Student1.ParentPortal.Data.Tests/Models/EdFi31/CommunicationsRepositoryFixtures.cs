using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Moq;
using NUnit.Framework;
using Student1.ParentPortal.Data.Models.EdFi31;
using Student1.ParentPortal.Data.Tests.Helpers;
using Student1.ParentPortal.Models.Shared;
using Student1.ParentPortal.Models.Student;

namespace Student1.ParentPortal.Data.Tests.Models.EdFi31
{
    [TestFixture]
    public class CommunicationsRepositoryFixtures
    {
        [Test]
        public async Task When_getting_an_admin_identity_with_a_valid_staff_email_should_return_an_admin_identity()
        {
            // Arrange
            // Supplied Data: Setting up our baseline of supplied data.
            var suppliedSchoolId = 1;
            var suppliedSchools = new List<School>
            {
                new School{ SchoolId = suppliedSchoolId, LocalEducationAgencyId = 10},
                new School{ SchoolId = 99, LocalEducationAgencyId = 99} // Should be filtered out.
            };

            var dbContextMock = new Mock<IEdFi31Context>();

            dbContextMock.Setup(p => p.Schools).Returns(DbContextMockingHelper.GetAsyncQueryableDbSetMock(suppliedSchools));

            var edFiContextMock = dbContextMock.Object;

            var suppliedGradesLevelModel = new GradesLevelModel{PageSize = 1, SkipRows = 0};

            // Act
            var repoUnderTest = new CommunicationsRepository(edFiContextMock);
           // var actualResult = await repoUnderTest.GetStudentListByGradeLevelsProgramsAndSearchTerm("notUsed", "term", suppliedGradesLevelModel,);

            // Assert
            //Assert.IsNotNull(actualResult);
           // Assert.AreEqual(1,actualResult.Count);

        }
    }
}
