angular.module('app')
    .config(['$stateProvider', function($stateProvider) {
        $stateProvider.state('app.parentLanding', {
                url: '/landing',
                //requireADLogin: true,
                views: {
                    'content@': { component:'parentLanding' }
                },
                resolve: {
                    model: ['api', function (api) {
                        return api.parents.getStudents();
                    }]
                }
            });
    }])
    .component('parentLanding', {
        bindings: {
            model: "<"
        }, // One way data binding.
        templateUrl: 'clientapp/modules/parent/landing/landing.view.html',
        controllerAs:'ctrl',
        controller: ['$location', 'api', '$rootScope', function ($location, api, $rootScope) {
            var ctrl = this;
            ctrl.isElementaty = false;
            ctrl.showDeliveryMethodOfContactDescription = false;
            ctrl.showCommunicationMessage = false;

            ctrl.$onInit = function () {
                $rootScope.$on('showProfileDescription', function (event, args) {
                    if (args.methodOfContact == null) {
                        ctrl.showDeliveryMethodOfContactDescription = true;
                    }
                    if (args.language == null) {
                        ctrl.showDeliveryMethodOfContactDescription = true;
                    }
                });

                api.students.setStudentIds(ctrl.model.map(function (x) { return x.studentUsi }));
                if (ctrl.model != undefined)
                    ctrl.isElementayGrade();

                if ($rootScope.featureToggles.comms && $rootScope.featureToggles.comms.enabled) {
                    ctrl.showCommunicationMessage = true;
                }
            }

            ctrl.isElementayGrade = function () {
                ctrl.model.forEach(function (student) {
                    if (student.gradeLevel == 'Third grade' || student.gradeLevel == '03') {
                        ctrl.isElementaty = true;
                    } else if (student.gradeLevel == 'Fourth grade' || student.gradeLevel == '04') {
                        ctrl.isElementaty = true;
                    } else if (student.gradeLevel == 'Fifth grade' || student.gradeLevel == '05') {
                        ctrl.isElementaty = true;
                    }
                });
                
            }
        }]
    });