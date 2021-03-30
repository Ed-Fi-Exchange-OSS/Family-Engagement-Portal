angular.module('app.directives')
    .component('indicator4', {
        bindings: {
            color: '@',
            indicatorTitle: '@',
            indicatorSubTitle: '@',
            indicatorText: '@',
            icon: '@',
            canDoDescriptors: '<',
            tooltip: '@',
            data: '<', // [{tooltip:'', value: 10, interpretation: ''}]
            bgclass: '@',
            subject: '<',
        },
        templateUrl: 'clientapp/modules/directives/indicator/indicator4.view.html',
        controllerAs: 'ctrl',
        controller: ['$location',function ($location) {
            var ctrl = this;

            ctrl.$onChanges = function (changes) {
                ctrl.setProfencyLevels();
            }

            ctrl.$onInit = function () {

                if (ctrl.data == null || ctrl.data == undefined || ctrl.data.length == 0)
                    return;

                if (ctrl.subject == 'No Subject' || !ctrl.data[0])
                    return;

                ctrl.setProfencyLevels();
            };
            ctrl.setProfencyLevels = function myfunction() {
                ctrl.gradeLevel = ctrl.getGradeLevel();
                ctrl.proficiencyLevel = Math.floor(ctrl.data[0].proficiencyLevel) + 1;
                if (ctrl.proficiencyLevel == 7)
                    ctrl.proficiencyLevel--;
                
                let existDescription = ctrl.canDoDescriptors
                    .find(cdd => cdd.subject == ctrl.subject
                        && cdd.gradeLevels.some(x => x == (ctrl.gradeLevel + 1))
                        && cdd.proficiency == ctrl.proficiencyLevel);
                
                if (existDescription != null && existDescription != undefined)
                    ctrl.description = existDescription.description;
            }
            ctrl.getGradeLevel = function () {
                switch (ctrl.data[0].gradelevel) {
                    case 'First grade':
                        return 1;
                    case 'Second grade':
                        return 2;
                    case 'Third grade':
                        return 3;
                    case 'Fourth grade':
                        return 4;
                    case 'Fifth grade':
                        return 5;
                    case 'Sixth grade':
                        return 6;
                    case 'Seventh grade':
                        return 7;
                    case 'Eighth grade':
                        return 8;
                    case 'Ninth grade':
                        return 9;
                    case 'Tenth grade':
                        return 10;
                    case 'Eleventh grade':
                        return 11;
                    case 'Twelfth grade':
                        return 12;
                    default:
                        return 0;
                }
            }
        }]
    });