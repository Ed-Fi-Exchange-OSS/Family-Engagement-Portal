angular.module('app.directives')
    .component('studentAllAboutMe', {
        bindings: {
            model: "<",
            link: '@'
        },
        templateUrl: 'clientapp/modules/directives/studentAllAboutMe/studentAllAboutMe.view.html',
        controllerAs: 'ctrl',
        controller: ["$scope", "$uibModal", "api", function ($scope, $uibModal, api) {
            var ctrl = this;

            ctrl.allAboutMeModel = {
                studentAllAboutId: 0,
                studentUsi: 0,
                question1: '',
                question2: '',
                question3: '',
                question4: '',
                question5: '',
                question6: '',
                question7: '',
                question8: '',
                question9: ''
            };

            ctrl.allAboutMeModelEdit = {
                studentAllAboutId: 0,
                studentUsi: 0,
                question1: '',
                question2: '',
                question3: '',
                question4: '',
                question5: '',
                question6: '',
                question7: '',
                question8: '',
                question9: ''
            };

            ctrl.edit = function () {
                ctrl.loadInformation();
                $scope.modalInstance = $uibModal.open({
                    templateUrl: "modalAllAboutMe.html",
                    scope: $scope,
                    size: 'xl'
                });
            };

            ctrl.setModelToAPI = function () {
                let model = {
                    prefferedName: ctrl.allAboutMeModelEdit.question1,
                    funFact: ctrl.allAboutMeModelEdit.question2,
                    typesOfBook: ctrl.allAboutMeModelEdit.question3,
                    favoriteAnimal: ctrl.allAboutMeModelEdit.question4,
                    favoriteThingToDo: ctrl.allAboutMeModelEdit.question5,
                    favoriteSubjectSchool: ctrl.allAboutMeModelEdit.question6,
                    oneThingWant: ctrl.allAboutMeModelEdit.question7,
                    learnToDo: ctrl.allAboutMeModelEdit.question8,
                    learningThings: ctrl.allAboutMeModelEdit.question9,
                    studentAllAboutId: ctrl.allAboutMeModelEdit.studentAllAboutId,
                    studentUsi: ctrl.allAboutMeModelEdit.studentUsi
                };
                return model;
            };

            ctrl.setEditModelToView = function () {
                ctrl.allAboutMeModel.question1 = ctrl.allAboutMeModelEdit.question1;
                ctrl.allAboutMeModel.question2 = ctrl.allAboutMeModelEdit.question2;
                ctrl.allAboutMeModel.question3 = ctrl.allAboutMeModelEdit.question3;
                ctrl.allAboutMeModel.question4 = ctrl.allAboutMeModelEdit.question4;
                ctrl.allAboutMeModel.question5 = ctrl.allAboutMeModelEdit.question5;
                ctrl.allAboutMeModel.question6 = ctrl.allAboutMeModelEdit.question6;
                ctrl.allAboutMeModel.question7 = ctrl.allAboutMeModelEdit.question7;
                ctrl.allAboutMeModel.question8 = ctrl.allAboutMeModelEdit.question8;
                ctrl.allAboutMeModel.question9 = ctrl.allAboutMeModelEdit.question9;
                ctrl.allAboutMeModel.studentAllAboutId = ctrl.allAboutMeModelEdit.studentAllAboutId;
                ctrl.allAboutMeModel.studentUsi = ctrl.allAboutMeModelEdit.studentUsi;
            };

            ctrl.save = function () {

                let currentModel = ctrl.setModelToAPI();

                if (ctrl.allAboutMeModelEdit.studentAllAboutId > 0) {
                    api.students.updateStudentAllAboutMe(currentModel).then(response => {
                        ctrl.setEditModelToView();
                        $scope.modalInstance.close(null);
                    });
                }
                else {
                    api.students.addStudentAllAboutMe(currentModel).then(response => {
                        if (response != null && response.studentAllAboutId > 0) {
                            ctrl.allAboutMeModelEdit.studentAllAboutId = response.studentAllAboutId;
                            ctrl.setEditModelToView();
                        }
                        $scope.modalInstance.close(null);
                    });
                }
            };

            ctrl.cancel = function () {
                $scope.modalInstance.close(null);
            };

            ctrl.$onInit = function () {
                if (ctrl.model.studentAllAboutMe != null) {
                    ctrl.allAboutMeModel.question1 = ctrl.model.studentAllAboutMe.prefferedName;
                    ctrl.allAboutMeModel.question2 = ctrl.model.studentAllAboutMe.funFact;
                    ctrl.allAboutMeModel.question3 = ctrl.model.studentAllAboutMe.typesOfBook;
                    ctrl.allAboutMeModel.question4 = ctrl.model.studentAllAboutMe.favoriteAnimal;
                    ctrl.allAboutMeModel.question5 = ctrl.model.studentAllAboutMe.favoriteThingToDo;
                    ctrl.allAboutMeModel.question6 = ctrl.model.studentAllAboutMe.favoriteSubjectSchool;
                    ctrl.allAboutMeModel.question7 = ctrl.model.studentAllAboutMe.oneThingWant;
                    ctrl.allAboutMeModel.question8 = ctrl.model.studentAllAboutMe.learnToDo;
                    ctrl.allAboutMeModel.question9 = ctrl.model.studentAllAboutMe.learningThings;

                    ctrl.allAboutMeModel.studentAllAboutId = ctrl.model.studentAllAboutMe.studentAllAboutId;
                    ctrl.allAboutMeModel.studentUsi = ctrl.model.studentAllAboutMe.studentUsi;
                }
                else {
                    ctrl.allAboutMeModel.studentUsi = ctrl.model.studentUsi;
                }
            };

            ctrl.loadInformation = function () {
                ctrl.allAboutMeModelEdit.question1 = ctrl.allAboutMeModel.question1;
                ctrl.allAboutMeModelEdit.question2 = ctrl.allAboutMeModel.question2;
                ctrl.allAboutMeModelEdit.question3 = ctrl.allAboutMeModel.question3;
                ctrl.allAboutMeModelEdit.question4 = ctrl.allAboutMeModel.question4;
                ctrl.allAboutMeModelEdit.question5 = ctrl.allAboutMeModel.question5;
                ctrl.allAboutMeModelEdit.question6 = ctrl.allAboutMeModel.question6;
                ctrl.allAboutMeModelEdit.question7 = ctrl.allAboutMeModel.question7;
                ctrl.allAboutMeModelEdit.question8 = ctrl.allAboutMeModel.question8;
                ctrl.allAboutMeModelEdit.question9 = ctrl.allAboutMeModel.question9;
                ctrl.allAboutMeModelEdit.studentAllAboutId = ctrl.allAboutMeModel.studentAllAboutId;
                ctrl.allAboutMeModelEdit.studentUsi = ctrl.allAboutMeModel.studentUsi;
            };
            
        }]
    });