angular.module('app.directives')
    .component('studentSuccessTeam', {
        bindings: {
            data: "<"
        }, // One way data binding.
        templateUrl: 'clientapp/modules/directives/studentSuccessTeam/studentSuccessTeam.view.html',
        controllerAs: 'ctrl',
        controller: ['api', function (api) {
            var ctrl = this;

            ctrl.model = {
                student: {},//$scope.data,
                successTeam: []
            };

            ctrl.$onInit = function() {
                ctrl.model.student = ctrl.data;
                api.students.getStudentSuccessTeamMembers(ctrl.data.studentUsi).then(function (successTeam) {
                    ctrl.model.student.successTeamMembers = successTeam;
                });
                processSuccessTeam(ctrl.data.successTeamMembers);
            }

            var colors = ['red', 'pink', 'deep-purple', 'blue', 'cyan', 'yellow', 'orange', 'brown', 'light-blue'];
            ctrl.getColor = function (index) {
                return colors[index%colors.length];
            };

            function processSuccessTeam(teamMemebers) {

                switch (teamMemebers.length) {
                    case 1:
                        ctrl.model.successTeam[1] = teamMemebers[0];
                        break;
                    case 2:
                        ctrl.model.successTeam[3] = teamMemebers[0];
                        ctrl.model.successTeam[5] = teamMemebers[1];
                        break;
                    case 3:
                        ctrl.model.successTeam[1] = teamMemebers[0];
                        ctrl.model.successTeam[6] = teamMemebers[1];
                        ctrl.model.successTeam[8] = teamMemebers[2];
                        break;
                    case 4:
                        ctrl.model.successTeam[0] = teamMemebers[0];
                        ctrl.model.successTeam[2] = teamMemebers[1];
                        ctrl.model.successTeam[6] = teamMemebers[2];
                        ctrl.model.successTeam[8] = teamMemebers[3];
                        break;
                    case 5:
                        ctrl.model.successTeam[1] = teamMemebers[0];
                        ctrl.model.successTeam[3] = teamMemebers[1];
                        ctrl.model.successTeam[5] = teamMemebers[2];
                        ctrl.model.successTeam[6] = teamMemebers[3];
                        ctrl.model.successTeam[8] = teamMemebers[4];
                        break;
                    case 6:
                        ctrl.model.successTeam[0] = teamMemebers[0];
                        ctrl.model.successTeam[2] = teamMemebers[1];
                        ctrl.model.successTeam[3] = teamMemebers[2];
                        ctrl.model.successTeam[5] = teamMemebers[3];
                        ctrl.model.successTeam[6] = teamMemebers[4];
                        ctrl.model.successTeam[8] = teamMemebers[5];
                        break;
                    case 7:
                        ctrl.model.successTeam[0] = teamMemebers[0];
                        ctrl.model.successTeam[1] = teamMemebers[1];
                        ctrl.model.successTeam[2] = teamMemebers[2];
                        ctrl.model.successTeam[3] = teamMemebers[3];
                        ctrl.model.successTeam[5] = teamMemebers[4];
                        ctrl.model.successTeam[6] = teamMemebers[5];
                        ctrl.model.successTeam[8] = teamMemebers[6];
                        break;
                    case 8:
                        ctrl.model.successTeam[0] = teamMemebers[0];
                        ctrl.model.successTeam[1] = teamMemebers[1];
                        ctrl.model.successTeam[2] = teamMemebers[2];
                        ctrl.model.successTeam[3] = teamMemebers[3];
                        //ctrl.model.successTeam[4] = teamMemebers[0];
                        ctrl.model.successTeam[5] = teamMemebers[4];
                        ctrl.model.successTeam[6] = teamMemebers[5];
                        ctrl.model.successTeam[7] = teamMemebers[6];
                        ctrl.model.successTeam[8] = teamMemebers[7];
                        break;
                    default:
                        for (var i = 0; i < teamMemebers.length; i++)
                            ctrl.model.successTeam[i] = teamMemebers[i];
                }
            }

        }]
    });