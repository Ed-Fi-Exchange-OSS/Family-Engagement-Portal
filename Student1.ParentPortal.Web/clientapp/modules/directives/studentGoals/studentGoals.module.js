angular.module('app.directives')
    .component('studentGoals', {
        bindings: {
            model: "<",
            link: '@'
        },
        templateUrl: 'clientapp/modules/directives/studentGoals/studentGoals.view.html',
        controllerAs: 'ctrl',
        controller: ["$scope", "$uibModal", "api", function ($scope, $uibModal, api) {
            var ctrl = this;

            ctrl.goalsAcademic = [];
            ctrl.goalsPersonal = [];
            ctrl.goalsCareer = [];

            ctrl.olderGoalsAcademic = [];
            ctrl.olderGoalsPersonal = [];
            ctrl.olderGoalsCareer = [];

            ctrl.$onInit = function () {
                if (ctrl.model.studentGoals != null && ctrl.model.studentGoals.length > 0) {
                    let currentArray = [];
                    ctrl.model.studentGoals.forEach(item => {
                        item.steps = item.steps.sort((a, b) => b.isActive - a.isActive);
                        if (item.completed != null && item.completed != '') {
                            switch (item.goalType) {
                                case 'A':
                                    ctrl.olderGoalsAcademic.push(item);
                                    break;
                                case 'P':
                                    ctrl.olderGoalsPersonal.push(item);
                                    break;
                                case 'C':
                                    ctrl.olderGoalsCareer.push(item);
                                    break;
                            }
                        }
                        else {
                            switch (item.goalType) {
                                case 'A':
                                    currentArray = ctrl.goalsAcademic;
                                    break;
                                case 'P':
                                    currentArray = ctrl.goalsPersonal;
                                    break;
                                case 'C':
                                    currentArray = ctrl.goalsCareer;
                                    break;
                            }
                            ctrl.calculate(item);
                            currentArray.push(item);
                        }
                    });
                    ctrl.orderLists();
                }

                api.students.getStudentGoalLabels().then(response => {
                    response.forEach(item => {
                        $scope.Alltags.push({
                            id: item.studentGoalLabelId,
                            text: item.label
                        });
                    });
                });
            };

            ctrl.orderLists = function () {
                ctrl.goalsAcademic = ctrl.goalsAcademic.sort((a, b) => (new Date(a.dateScheduled)) - (new Date(b.dateScheduled)));
                ctrl.goalsPersonal = ctrl.goalsPersonal.sort((a, b) => (new Date(a.dateScheduled)) - (new Date(b.dateScheduled)));
                ctrl.goalsCareer = ctrl.goalsCareer.sort((a, b) => (new Date(a.dateScheduled)) - (new Date(b.dateScheduled)));

                ctrl.olderGoalsAcademic = ctrl.olderGoalsAcademic.sort((a, b) => (new Date(a.dateScheduled)) - (new Date(b.dateScheduled)));
                ctrl.olderGoalsPersonal = ctrl.olderGoalsPersonal.sort((a, b) => (new Date(a.dateScheduled)) - (new Date(b.dateScheduled)));
                ctrl.olderGoalsCareer = ctrl.olderGoalsCareer.sort((a, b) => (new Date(a.dateScheduled)) - (new Date(b.dateScheduled)));
            };

            ctrl.calculate = function (result) {
                let activeSteps = 0;
                result.steps.forEach(function (item) { if (item.isActive) activeSteps++; });
                let totalCompleted = 0;
                result.steps.forEach(function (item) { if (item.completed && item.isActive) totalCompleted++; });
                let percentage = Math.ceil((totalCompleted * 100) / activeSteps);
                let progress = Math.ceil((percentage * 250) / 100);
                if (percentage >= 100) { percentage = 100; }
                result.progress = progress;
                result.progressPercentage = percentage + '%';
            };

            ctrl.addGoal = function (goalType, goalTypeText) {
                $scope.goalActionType = 'add';
                $scope.goalType = goalType;
                $scope.goalTypeText = goalTypeText;
                $scope.initGoalModalInfo(null);
                $scope.modalInstance = $uibModal.open({
                    templateUrl: "modal.html",
                    scope: $scope
                });
                $scope.modalInstance.result.then(function (result) {
                    if (result != null) {
                        switch (result.type) {
                            case 'Academic':
                                result.goalType = 'A';
                                break;

                            case 'Personal':
                                result.goalType = 'P';
                                break;

                            case 'Career':
                                result.goalType = 'C';
                                break;
                        }

                        result.gradeLevel = ctrl.model.gradeLevel;
                        result.studentUsi = ctrl.model.studentUsi;
                        result.id = ctrl.model.studentUsi;
                        api.students.addStudentGoal(result).then(response => {
                            ctrl.calculate(response);
                            switch (result.type) {
                                case 'Academic':
                                    ctrl.goalsAcademic.push(response);
                                    break;

                                case 'Personal':
                                    ctrl.goalsPersonal.push(response);
                                    break;

                                case 'Career':
                                    ctrl.goalsCareer.push(response);
                                    break;
                            }
                            ctrl.orderLists();
                        });
                    }
                }, function () { });
            };

            ctrl.editGoal = function (goalType, goalTypeText, currentGoal) {
                $scope.goalActionType = 'edit';
                $scope.goalType = goalType;
                $scope.goalTypeText = goalTypeText;
                $scope.initGoalModalInfo(currentGoal);
                $scope.modalInstance = $uibModal.open({
                    templateUrl: "modal.html",
                    scope: $scope
                });
                $scope.modalInstance.result.then(function (result) {
                    if (result != null) {

                        result.id = ctrl.model.studentUsi;
                        result.studentUsi = ctrl.model.studentUsi;

                        if (result.completed != null && result.completed != '') {
                            result.dateCompleted = new Date();
                        }

                        api.students.updateStudentGoal(result).then(response => {
                            ctrl.calculate(response);
                            response.steps = response.steps.sort((a, b) => b.isActive - a.isActive);

                            if (result.completed != null && result.completed != '') {
                                let arrayToSearch = [];
                                let arrayItems = [];
                                switch (result.type) {
                                    case 'Academic':
                                        ctrl.olderGoalsAcademic.push(response);
                                        arrayToSearch = ctrl.goalsAcademic;
                                        break;

                                    case 'Personal':
                                        ctrl.olderGoalsPersonal.push(response);
                                        arrayToSearch = ctrl.goalsPersonal;
                                        break;

                                    case 'Career':
                                        ctrl.olderGoalsCareer.push(response);
                                        arrayToSearch = ctrl.goalsCareer;
                                        break;
                                }
                                for (let i = 0; i < arrayToSearch.length; i++) {
                                    if (arrayToSearch[i].studentGoalId != response.studentGoalId) {
                                        arrayItems.push(arrayToSearch[i]);
                                    }
                                }
                                switch (result.type) {
                                    case 'Academic':
                                        ctrl.goalsAcademic = arrayItems;
                                        break;

                                    case 'Personal':
                                        ctrl.goalsPersonal = arrayItems;
                                        break;

                                    case 'Career':
                                        ctrl.goalsCareer = arrayItems;
                                        break;
                                }
                            }
                            else {
                                let arrayToSearch = [];
                                switch (result.type) {
                                    case 'Academic':
                                        arrayToSearch = ctrl.goalsAcademic;
                                        break;

                                    case 'Personal':
                                        arrayToSearch = ctrl.goalsPersonal;
                                        break;

                                    case 'Career':
                                        arrayToSearch = ctrl.goalsCareer;
                                        break;
                                }
                                for (let i = 0; i < arrayToSearch.length; i++) {
                                    if (arrayToSearch[i].studentGoalId == response.studentGoalId) {
                                        arrayToSearch[i] = response;
                                    }
                                }
                            }

                            ctrl.orderLists();
                        });
                    }
                }, function () { });
            };

            ctrl.viewOlderGoals = function (goalType, goalTypeText) {
                $scope.goalType = goalType;
                $scope.goalTypeText = goalTypeText;
                $scope.initOlderGoals();
                $scope.modalInstance = $uibModal.open({
                    templateUrl: "oldergoals.html",
                    scope: $scope,
                    size: 'xl'
                });
                $scope.modalInstance.result.then(function (result) {
                }, function () { });
            };

            ctrl.changeStep = function (goal, step) {
                api.students.updateStudentGoalStep(step).then(response => {
                    if (response) {
                        ctrl.calculate(goal);
                    }
                });
            };

            ctrl.getFormatDate = function (dateObj) {
                if (dateObj == null) {
                    dateObj = new Date();
                }
                else {
                    dateObj = new Date(dateObj);
                }
                return (((dateObj.getMonth() + 1) > 10 ? ((dateObj.getMonth() + 1)) : ('0' + (dateObj.getMonth() + 1))) + '/' + (dateObj.getDate() > 10 ? (dateObj.getDate()) : ('0' + dateObj.getDate())) + '/' + dateObj.getFullYear());
            };

            //new goals functionality
            $scope.goalActionType = '';
            $scope.submited = false;
            $scope.modalInstance = null;
            $scope.modalInstance2 = null;
            $scope.goalType = '';
            $scope.goalTypeText = '';
            $scope.goalModel = {
                goal: '',
                dateGoalCreated: null,
                dateScheduled: null,
                steps: [],
                additional: '',
                stepName: '',
                completed: ''
            };
            $scope.initGoalModalInfo = function (currentGoal) {
                ctrl.selectedLabel = null;
                $scope.submited = false;
                $scope.goalModel = {
                    goal: '',
                    dateGoalCreated: new Date(),
                    dateScheduled: null,
                    steps: [],
                    additional: '',
                    stepName: '',
                    completed: ''
                };
                $scope.tags = [];
                if (currentGoal != null) {
                    $scope.goalModel.goal = currentGoal.goal;
                    $scope.goalModel.dateGoalCreated = new Date(currentGoal.dateGoalCreated);
                    $scope.goalModel.dateScheduled = new Date(currentGoal.dateScheduled);
                    if (currentGoal.steps != null && currentGoal.steps.length > 0) {
                        currentGoal.steps.forEach(step => {
                            $scope.goalModel.steps.push({
                                studentGoalId: step.studentGoalId,
                                studentGoalStepId: step.studentGoalStepId,
                                stepName: step.stepName,
                                completed: step.completed,
                                isActive: step.isActive,
                                studentGoalInterventionId: step.studentGoalInterventionId
                            });
                        });
                    }
                    $scope.goalModel.additional = currentGoal.additional;
                    $scope.goalModel.completed = currentGoal.completed;
                    $scope.goalModel.studentUsi = currentGoal.studentUsi;
                    $scope.goalModel.studentGoalId = currentGoal.studentGoalId;
                    $scope.goalModel.goalType = currentGoal.goalType;
                    $scope.goalModel.gradeLevel = currentGoal.gradeLevel;
                    $scope.goalModel.labels = currentGoal.labels;
                    if (currentGoal.labels != null && currentGoal.labels != '') {
                        $scope.Alltags.forEach(element => {
                            if (element.id == currentGoal.labels) {
                                ctrl.selectedLabel = element;
                            }
                        });
                    }
                }
            };
            $scope.saveGoal = function () {
                $scope.submited = true;
                if (!$scope.validate('goal') && !$scope.validate('dateGoalCreated') && !$scope.validate('steps') && !$scope.validate('dateScheduled') && !$scope.validate('dates')) {
                    if (ctrl.selectedLabel != null && ctrl.selectedLabel != {} && ctrl.selectedLabel != undefined) {
                        $scope.goalModel.labels = ctrl.selectedLabel.id;
                    }
                    //let tagsSelected = '';
                    //tagsSelected = $scope.tags.map(e => e.id).join(',');
                    //$scope.goalModel.labels = tagsSelected;
                    $scope.goalModel.type = $scope.goalType;
                    $scope.modalInstance.close($scope.goalModel);
                }
            };
            $scope.cancelGoal = function () {
                $scope.modalInstance.close(null);
            };
            $scope.validate = function (fieldToValidate) {
                if ($scope.submited == false) return false;
                switch (fieldToValidate) {
                    case 'interventionDescription':
                        if ($scope.interventionModel.description == null || $scope.interventionModel.description == '') return true;
                        break;

                    case 'interventionSteps':
                        if ($scope.interventionModel.steps.length == 0) return true;
                        break;

                    case 'interventionDate':
                        if ($scope.interventionModel.dateChanged == null || $scope.interventionModel.dateChanged == '') return true;
                        break;

                    case 'goal':
                        if ($scope.goalModel.goal == null || $scope.goalModel.goal == '') return true;
                        break;

                    case 'dateGoalCreated':
                        if ($scope.goalModel.dateGoalCreated == null || $scope.goalModel.dateGoalCreated == '') return true;
                        break;

                    case 'dateScheduled':
                        if ($scope.goalModel.dateScheduled == null || $scope.goalModel.dateScheduled == '') return true;
                        break;

                    case 'steps':
                        if ($scope.goalModel.steps.length == 0) return true;
                        break;

                    case 'dates':
                        if ($scope.goalModel.dateGoalCreated != null && $scope.goalModel.dateGoalCreated != '' &&
                            $scope.goalModel.dateScheduled != null && $scope.goalModel.dateScheduled != '') {
                            if ($scope.goalModel.dateGoalCreated > $scope.goalModel.dateScheduled) {
                                return true
                            }
                        }
                        break;
                }
                return false;
            };
            $scope.addStep = function () {
                if ($scope.goalModel.stepName != null && $scope.goalModel.stepName != '') {
                    $scope.goalModel.steps.push({
                        stepName: $scope.goalModel.stepName,
                        completed: false,
                        isActive: true,
                    });
                    $scope.goalModel.stepName = '';
                }
            };
            $scope.removeStep = function (index) {
                let aux = [];
                for (let i = 0; i < $scope.goalModel.steps.length; i++) {
                    if (index != i) {
                        aux.push($scope.goalModel.steps[i]);
                    }
                }
                $scope.goalModel.steps = aux;
            };

            $scope.changeIntervention = function () {
                $scope.interventionModel = {
                    description: '',
                    dateChanged: new Date(),
                    steps: [],
                    stepName: ''
                };
                $scope.modalInstance2 = $uibModal.open({
                    templateUrl: "modalCI.html",
                    scope: $scope
                });
            };
            $scope.interventionModel = {
                description: '',
                dateChanged: null,
                steps: [],
                stepName: ''
            };
            $scope.addInterventionStep = function () {
                if ($scope.interventionModel.stepName != null && $scope.interventionModel.stepName != '') {
                    $scope.interventionModel.steps.push({
                        stepName: $scope.interventionModel.stepName,
                        completed: false
                    });
                    $scope.interventionModel.stepName = '';
                }
            };
            $scope.saveIntervention = function () {
                $scope.submited = true;
                if (!$scope.validate('interventionDescription') && !$scope.validate('interventionDate') && !$scope.validate('interventionSteps')) {
                    $scope.interventionModel.studentUsi = ctrl.model.studentUsi;
                    $scope.interventionModel.studentGoalId = $scope.goalModel.studentGoalId;
                    $scope.interventionModel.interventionStart = $scope.interventionModel.dateChanged;
                    api.students.updateStudentGoalIntervention($scope.interventionModel).then(response => {
                        if (response != null) {
                            let arrayToSearch = [];
                            switch ($scope.goalType) {
                                case 'Academic':
                                    arrayToSearch = ctrl.goalsAcademic;
                                    break;

                                case 'Personal':
                                    arrayToSearch = ctrl.goalsPersonal;
                                    break;

                                case 'Career':
                                    arrayToSearch = ctrl.goalsCareer;
                                    break;
                            }
                            ctrl.calculate(response);
                            response.steps = response.steps.sort((a, b) => b.isActive - a.isActive);
                            for (let i = 0; i < arrayToSearch.length; i++) {
                                if (arrayToSearch[i].studentGoalId == response.studentGoalId) {
                                    arrayToSearch[i] = response;
                                }
                            }
                            ctrl.orderLists();
                            $scope.modalInstance.close(null);
                            $scope.modalInstance2.close(null);
                        }
                    });
                }
            };
            $scope.cancelIntervention = function () {
                $scope.modalInstance2.close(null);
            };

            //labels
            ctrl.selectedLabel = {};
            $scope.Alltags = [];

            //view older goals
            $scope.currentOlderGoals = [];
            $scope.initOlderGoals = function () {
                $scope.currentOlderGoals = [];
                switch ($scope.goalType) {
                    case 'Academic':
                        $scope.currentOlderGoals = ctrl.olderGoalsAcademic;
                        break;

                    case 'Personal':
                        $scope.currentOlderGoals = ctrl.olderGoalsPersonal;
                        break;

                    case 'Career':
                        $scope.currentOlderGoals = ctrl.olderGoalsCareer;
                        break;
                }
            };
            $scope.cancelViewOlderGoals = function () {
                $scope.modalInstance.close(null);
            };

            //datetime picker
            $scope.format = 'MM/dd/yyyy';
            $scope.popup1 = {
                opened: false
            };
            $scope.open1 = function () {
                $scope.popup1.opened = true;
            };
            $scope.popup2 = {
                opened: false
            };
            $scope.open2 = function () {
                $scope.popup2.opened = true;
            };
            $scope.popup3 = {
                opened: false
            };
            $scope.open3 = function () {
                $scope.popup3.opened = true;
            };
            $scope.dateOptions = {
                //dateDisabled: true,
                formatYear: 'yyyy',
                //maxDate: new Date(2020, 5, 22),
                //minDate: new Date(),
                startingDay: 1
            };
        }]
    });

