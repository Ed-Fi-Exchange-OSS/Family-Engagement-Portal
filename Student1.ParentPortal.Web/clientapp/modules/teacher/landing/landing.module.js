angular.module('app')
    .config(['$stateProvider', function($stateProvider) {
        $stateProvider.state('app.teacherLanding', {
                url: '/teacherLanding',
                requireADLogin: true,
                views: {
                    'content@': { component:'teacherLanding' }
                },
                resolve: {
                    sections: ['api', function (api) { return api.teachers.getAllSections(); }],
                }
            });
    }])
    .component('teacherLanding', {
        bindings: {
            sections: "<",
            model: "<"
        }, // One way data binding.
        templateUrl: 'clientapp/modules/teacher/landing/landing.view.html',
        controllerAs:'ctrl',
        controller: ['api', '$translate', function (api, $translate) {

            var ctrl = this;
            ctrl.selectedOrder = {};
            ctrl.search = {};
            ctrl.orderBy = {
                expression: { propertyName: '', reverse: false },
                properties: [
                    { displayName: $translate.instant('Student Last Name'), displayOrder: $translate.instant('a to z'), order: 'ascending', propertyName: 'lastSurname' },
                    { displayName: $translate.instant('Student Last Name'), displayOrder: $translate.instant('z to a'),  order: 'descending', propertyName: 'lastSurname' },
                    { displayName: $translate.instant('Absences'), displayOrder: $translate.instant('leastAbsences'), order: 'ascending', propertyName: 'adaAbsences' },
                    { displayName: $translate.instant('Absences'), displayOrder: $translate.instant('mostAbsences'), order: 'descending', propertyName: 'adaAbsences' },
                    { displayName: $translate.instant('Discipline'), displayOrder: $translate.instant('leastDisciplineIncidents'), order: 'ascending', propertyName: 'ytdDisciplineIncidentCount' },
                    { displayName: $translate.instant('Discipline'), displayOrder: $translate.instant('mostDisciplineIncidents'), order: 'descending', propertyName: 'ytdDisciplineIncidentCount' },
                    { displayName: $translate.instant('GPA'), displayOrder: $translate.instant('lowestGPA'), order: 'ascending', propertyName: 'ytdgpa' },
                    { displayName: $translate.instant('GPA'), displayOrder: $translate.instant('highestGPA'), order: 'descending', propertyName: 'ytdgpa' },
                ],
                sortBy: function () {
                    // Verify asc or desc.
                    ctrl.orderBy.expression.reverse = ctrl.selectedOrder.order === 'ascending' ? false : true;
                    ctrl.orderBy.expression.propertyName = ctrl.selectedOrder.propertyName;
                }
            };

            ctrl.$onInit = function () {
                // Set the selectedSection to default
                ctrl.sections.unshift({ courseTitle: 'All Sections' });
                ctrl.selectedSection = ctrl.sections[0];
            }

            ctrl.getTeacherStudents = function () {
                var request = { section: ctrl.selectedSection, studentName: ctrl.search.name };

                api.teachers.getStudentsInSection(request).then(function (data) {
                    ctrl.model = data;
                    api.students.setStudentIds(ctrl.model.map(function (x) { return x.studentUsi }));
                });
            };
        }]
    });