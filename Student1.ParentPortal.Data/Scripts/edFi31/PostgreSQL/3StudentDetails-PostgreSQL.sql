DO $$
BEGIN

	/* working  */

	CREATE TABLE ParentPortal.StudentAllAbout(
		StudentAllAboutId int GENERATED ALWAYS AS IDENTITY,
		StudentUSI int NOT NULL,
		PrefferedName Text NULL,
		FunFact Text NULL,
		TypesOfBook Text NULL,
		FavoriteAnimal Text NULL,
		FavoriteThingToDo Text NULL,
		FavoriteSubjectSchool Text NULL,
		OneThingWant Text NULL,
		LearnToDo Text NULL,
		LearningThings Text NULL,
		DateCreated Timestamp(3) NOT NULL,
		DateUpdated Timestamp(3) NOT NULL,
		PRIMARY KEY(StudentAllAboutId)
	);

	CREATE TABLE ParentPortal.AdminStudentDetailFeatures(
		AdminStudentDetailFeaturesId int GENERATED ALWAYS AS IDENTITY,
		Profile Boolean NOT NULL,
		AttendanceIndicator Boolean NOT NULL,
		CourseAverageIndicator Boolean NOT NULL,
		BehaviorIndicator Boolean NOT NULL,
		MissingAssignmentsIndicator Boolean NOT NULL,
		AllAboutMe Boolean NOT NULL,
		Goals Boolean NOT NULL,
		AttendanceLog Boolean NOT NULL,
		BehaviorLog Boolean NOT NULL,
		CourseGrades Boolean NOT NULL,
		MissingAssignments Boolean NOT NULL,
		Calendar Boolean NOT NULL,
		SuccessTeam Boolean NOT NULL,
		CollegeInitiativeCorner Boolean NOT NULL,
		ARC Boolean NOT NULL,
		STAARAssessment Boolean NOT NULL,
		Assessment Boolean NOT NULL,
		DateCreated Timestamp(3) NOT NULL,
		DateUpdated Timestamp(3) NOT NULL,
		PRIMARY KEY(AdminStudentDetailFeaturesId)
	);

	CREATE TABLE ParentPortal.StudentGoalIntervention(
		StudentGoalInterventionId int GENERATED ALWAYS AS IDENTITY,
		StudentUSI int NOT NULL,
		StudentGoalId int NOT NULL,
		Description Text NULL,
		InterventionStart Timestamp(3) NOT NULL,
		DateCreated Timestamp(3) NOT NULL,
		DateUpdated Timestamp(3) NOT NULL,
		PRIMARY KEY(StudentGoalInterventionId)
	);

	CREATE TABLE ParentPortal.StudentGoal(
		StudentGoalId int GENERATED ALWAYS AS IDENTITY,
		StudentUSI int NOT NULL,
		GoalType Varchar(10) NOT NULL,
		Goal Text NOT NULL,
		GradeLevel Text NOT NULL,
		DateGoalCreated Timestamp(3) NOT NULL,
		DateScheduled Timestamp(3) NOT NULL,
		DateCompleted Timestamp(3) NULL,
		Additional Text NOT NULL,
		Completed Varchar(10) NOT NULL,
		DateCreated Timestamp(3) NOT NULL,
		DateUpdated Timestamp(3) NOT NULL,
		Labels Text NULL,
		PRIMARY KEY(StudentGoalId)
	);

	CREATE TABLE ParentPortal.StudentGoalStep(
		StudentGoalStepId int GENERATED ALWAYS AS IDENTITY,
		StudentGoalId int NOT NULL,
		StepName Text NOT NULL,
		Completed Boolean NOT NULL,
		DateCreated Timestamp(3) NOT NULL,
		DateUpdated Timestamp(3) NOT NULL,
		IsActive Boolean NOT NULL,
		StudentGoalInterventionId int NULL,
		PRIMARY KEY(StudentGoalStepId)
	);

	ALTER TABLE ONLY ParentPortal.StudentGoalStep ADD CONSTRAINT FK_StudentGoalStep_StudentGoal FOREIGN KEY (StudentGoalId) 
    REFERENCES ParentPortal.StudentGoal (StudentGoalId);

	CREATE TABLE ParentPortal.StudentGoalLabel(
		StudentGoalLabelId int GENERATED ALWAYS AS IDENTITY,
		Label Text NOT NULL,
		DateCreated Timestamp(3) NOT NULL,
		DateUpdated Timestamp(3) NOT NULL,
		PRIMARY KEY(StudentGoalLabelId)
	);

	INSERT INTO ParentPortal.StudentGoalLabel(Label, DateCreated, DateUpdated) VALUES ('Reading',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
	INSERT INTO ParentPortal.StudentGoalLabel(Label, DateCreated, DateUpdated) VALUES ('Writing',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
	INSERT INTO ParentPortal.StudentGoalLabel(Label, DateCreated, DateUpdated) VALUES ('Math',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
	INSERT INTO ParentPortal.StudentGoalLabel(Label, DateCreated, DateUpdated) VALUES ('Social Studies',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
	INSERT INTO ParentPortal.StudentGoalLabel(Label, DateCreated, DateUpdated) VALUES ('Science',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
	INSERT INTO ParentPortal.StudentGoalLabel(Label, DateCreated, DateUpdated) VALUES ('Literacy',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
	INSERT INTO ParentPortal.StudentGoalLabel(Label, DateCreated, DateUpdated) VALUES ('Art',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
	INSERT INTO ParentPortal.StudentGoalLabel(Label, DateCreated, DateUpdated) VALUES ('Music',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
	INSERT INTO ParentPortal.StudentGoalLabel(Label, DateCreated, DateUpdated) VALUES ('CTE',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
	INSERT INTO ParentPortal.StudentGoalLabel(Label, DateCreated, DateUpdated) VALUES ('PE',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
END $$ 