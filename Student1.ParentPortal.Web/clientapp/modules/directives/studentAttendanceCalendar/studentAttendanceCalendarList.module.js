//require('./attendance-calendar.style.scss');
angular
    .module('app.directives')
    .directive('studentAttendanceCalendarList', ['api', function (api) {
        return {
            restrict: 'E',
            scope: {
                model: '='
            },
            templateUrl: 'clientapp/modules/directives/studentAttendanceCalendar/studentAttendanceCalendarList.view.html',
            controllerAs: 'ctrl',
            controller: ['$scope', function (scope) {

                var ctrl = this;

                const calendarsperrow = 4;
                ctrl.model =
                    // group by rows of 4 months each
                    scope.model.reduce(function (accumulator, currentvalue, currentindex) {
                        let idx = ~~(currentindex / calendarsperrow); // integer result of division
                        if (accumulator[idx] == null) { accumulator[idx] = []; }
                        let row = accumulator[idx];
                        row.push(currentvalue);
                        return accumulator;
                    }, []);
                console.log(ctrl.model);
            }]
        };
    }]);