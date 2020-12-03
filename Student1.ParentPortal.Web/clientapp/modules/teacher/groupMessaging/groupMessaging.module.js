angular.module('app')
    .config(['$stateProvider', function ($stateProvider) {
        $stateProvider.state('app.groupMessaging', {
            url: '/messaging',
            //requireADLogin: true,
            views: {
                'content@': { component: 'groupMessaging' }
            },
            resolve: {
                sections: ['api', function (api) { return api.teachers.getAllSections(); }],
                languages: ['api', function (api) { return api.translate.getAvailableLanguages(); }],
            }
        });
    }])
    .component('groupMessaging', {
        bindings: {
            sections: "<",
            languages: "<"
        }, // One way data binding.
        templateUrl: 'clientapp/modules/teacher/groupMessaging/groupMessaging.view.html',
        controllerAs: 'ctrl',
        controller: ['api', '$translate', '$uibModal', 'stateStorage', function (api, $translate, $uibModal, stateStorage) {

            var ctrl = this;

            ctrl.resetStylesTextArea = '';
            ctrl.resetStylesInput = '';
            ctrl.sectionName = "";
            ctrl.modalBody = "";
            ctrl.message = {};

            ctrl.invalidMessage = false;
            ctrl.invalidSubject = false;
            ctrl.familyCount = {};

            ctrl.stateKey = 'teacherGroupMessage';

            ctrl.$onInit = function() {
                // Set the selectedSection to default
                ctrl.sections.unshift({ courseTitle: 'All Classes' });
                ctrl.selectedSection = ctrl.sections[0];
                ctrl.sectionChanged();
                ctrl.getParentsCount();

                var state = JSON.parse(stateStorage.getState(ctrl.stateKey));
                if (state != null) {
                    if (state.section != null) {
                        ctrl.selectedSection = ctrl.sections.find(function (p) { return p.courseTitle == state.section });
                        ctrl.sectionChanged();
                    }

                    if (state.subject != null)
                        ctrl.message.subject = state.subject;
                    if (state.body != null)
                        ctrl.message.body = state.body;
                } else {
                    ctrl.getParentsCount();
                }
            };

            ctrl.sectionChanged = function () {
                // Calculate the Section Name                
                if (!ctrl.selectedSection.classPeriodName)
                    ctrl.SectionName = ctrl.selectedSection.courseTitle;
                else
                    ctrl.SectionName = ctrl.selectedSection.courseTitle + " (" + ctrl.selectedSection.classPeriodName + ")";

                ctrl.getParentsCount();
            };

            ctrl.confirmSend = function () {
                return new Promise(
                    function (resolve) {
                        // Update the modalBody
                        ctrl.modalBody = $translate.instant('Principals Modal Message Body', { familyCount: ctrl.familyCount.familyMembersCount });
                        ctrl.buttonLabelCustom = $translate.instant('Principals Modal Button Label', { familyCount: ctrl.familyCount.familyMembersCount });
                        var modalInstance = $uibModal.open({
                            component: 'confirmationModal',
                            resolve: {
                                body: function () {
                                    return ctrl.modalBody;
                                },
                                confirmButtonLabel: function () {
                                    return ctrl.buttonLabelCustom;
                                }
                            }
                        }).result;

                    modalInstance.then(function (result) {
                        if (result)
                            ctrl.sendMessage();
                    }).catch(function (dismiss) { });
                    resolve();
                });
            };

            ctrl.sendMessage = function() {

                var request = {
                    section: ctrl.selectedSection,
                    message: ctrl.message.body.replace(/\n/g, " <br/> "),
                    subject: ctrl.message.subject
                };
                
                return api.communications.sendSectionGroupMessage(request).then(function () {
                    toastr.success($translate.instant('Message Teacher Sent'));
                    ctrl.message = {};
                    ctrl.parentsLanguages = [];

                    document.getElementById("messageSubject").classList.remove("ng-touched");
                    document.getElementById("messageBody").classList.remove("ng-touched");
                    ctrl.resetStylesTextArea = 'ng-untouched';
                    ctrl.resetStylesInput = 'ng-untouched';
                    stateStorage.removeState(ctrl.stateKey);
                });
            };

            ctrl.getParentsCount = function () {
                api.communications.getParentStudentCountInSection({ section: ctrl.selectedSection})
                    .then(function (data) {
                        ctrl.familyCount = data;
                    });
            }

            ctrl.saveState = function () {
                console.log(ctrl.selectedSection);
                var sub = ctrl.message.subject;
                var body = ctrl.message.body;
                if (sub == undefined)
                    sub = null;
                if (body == undefined)
                    body = null;

                stateStorage.setState(ctrl.stateKey, JSON.stringify({ subject: sub, body: body, section: ctrl.selectedSection.courseTitle }))
            }
        }]
    });