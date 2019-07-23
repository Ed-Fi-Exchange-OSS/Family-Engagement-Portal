angular.module('app.directives')
    .component('missingAssignments', {
        bindings: {
            model: "<",
            customParams: "<",
            studentUsi: "<"
        }, // One way data binding.
        templateUrl: 'clientapp/modules/directives/missingAssignments/missingAssignments.view.html',
        controllerAs: 'ctrl',
        controller: [function () {

            var ctrl = this;
            ctrl.showAll = false;
            ctrl.checkDate = function (days) {
                return days <= 42 // 6 weeks;
            }

            ctrl.checkSectionDates = function (section) {
                return section.assignments.some(function (assignment) { assignment.daysLate <=  42 });
            }

            ctrl.evalDaysLate = function (days) {

                var evaluation = null;
                // '.some()' is like foreach but you can break the loop by returning true.
                ctrl.customParams.thresholdRules.some(function (rule) {
                    if (eval(days + rule.operator + rule.value)) {
                        evaluation = rule.evaluation;
                        return true;
                    }
                });

                // Transform evaluation to css class to use for view
                switch (evaluation) {
                    case "excellent":
                        return "success";
                    case "good":
                        return "primary";
                    case "fair":
                        return "warning";
                    case "bad":
                        return "danger";
                    default:
                        return "danger";
                }
            };
        }]
    });