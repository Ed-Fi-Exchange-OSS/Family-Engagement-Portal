angular.module('app')
    .component('feedback', {
        templateUrl: 'clientapp/modules/directives/feedback/feedback.view.html',
        controllerAs: 'ctrl',
        controller: ['$rootScope', 'api', '$location', '$translate', function ($rootScope, api, $location, $translate) {
            var ctrl = this;

            ctrl.model = {
                feedback: true
            };

            $rootScope.$watch('feedback', function (newVal, oldVal) {
                ctrl.model.feedback = newVal;
            });

            ctrl.model.feedback = $rootScope.feedback;

            ctrl.persistFeedback = function () {
                const modeltoSend = {
                    issue: ctrl.model.issue,
                    subject: ctrl.model.subject,
                    description: ctrl.model.description,
                    currentUrl: $location.url()
                };
                

                return api.feedback.persist(modeltoSend).then(function (result) {
                    $rootScope.feedback = false;
                    toastr.success($translate.instant('We had successfully received your feedback') + ".");
                });

              
            }

            ctrl.close = function () {
                delete ctrl.model.subject;
                delete ctrl.model.issue;
                delete ctrl.model.description;

                $rootScope.feedback = false;
            }
        }]
    });